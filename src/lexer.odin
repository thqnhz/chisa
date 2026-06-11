package chisa

Lexer :: struct {
	source_code: string,
	source_len:  uint,
	current:     uint,
	line:        int,
	col:         int,
}

lexer := Lexer {
	current = 0,
	line    = 1,
	col     = 1,
}

// Advance to the next token
advance :: proc() {
	lexer.current += 1
	lexer.col += 1
}

// Check if a rune is a number
is_numeric :: proc(s: u8) -> bool {
	return s >= '0' && s <= '9'
}

// Check if a rune is a letter or an underscore
is_alpha :: proc(s: u8) -> bool {
	return s == '_' || (s >= 'a' && s <= 'z') || (s >= 'A' && s <= 'Z')
}

// Check if a rune is a number, a letter or an underscore
is_alpha_numeric :: proc(s: u8) -> bool {
	return is_alpha(s) || is_numeric(s)
}

// Number tokenizing
number :: proc() {
	start := lexer.current
	start_col := lexer.col
	is_float := false

	// Advance thru all the number
	for is_numeric(lexer.source_code[lexer.current]) {
		advance()
	}
	// If the current character is a dot,
	// and the next one is a number,
	// continue advancing
	if lexer.source_code[lexer.current] == '.' &&
	   is_numeric(lexer.source_code[lexer.current + 1]) {
		is_float = true
		advance() // The dot
		for is_numeric(lexer.source_code[lexer.current]) {
			advance()
		}
	}
	add_token(
		type = is_float ? TokenType.FloatLiteral : TokenType.IntLiteral,
		lexeme = lexer.source_code[start:lexer.current],
		line = lexer.line,
		col = start_col,
	)
}

// Identifier or keyword tokenizing
identifier_or_keyword :: proc() {
	// Similar to number tokenizer above
	start := lexer.current
	start_col := lexer.col
	// Advance thru all the alphanumeric characters
	for is_alpha_numeric(lexer.source_code[lexer.current]) {
		advance()
	}
	// Keyword matching
	switch lexer.source_code[start:lexer.current] {
	case "let":
		add_token(TokenType.Let, lexeme = lexer.source_code[start:lexer.current])
	case "int":
		add_token(TokenType.IntType, lexeme = lexer.source_code[start:lexer.current])
	case "float":
		add_token(TokenType.FloatType, lexeme = lexer.source_code[start:lexer.current])
	case "string":
		add_token(TokenType.StringType, lexeme = lexer.source_code[start:lexer.current])
	case "bool":
		add_token(TokenType.BoolType, lexeme = lexer.source_code[start:lexer.current])
	case "true":
		add_token(TokenType.True, lexeme = lexer.source_code[start:lexer.current])
	case "false":
		add_token(TokenType.False, lexeme = lexer.source_code[start:lexer.current])
	case:
		add_token(TokenType.Identifier, lexeme = lexer.source_code[start:lexer.current])
	}
}

// Create a token with line and col defaults at current
// and add it to the list
add_token :: proc(
	type: TokenType,
	lexeme: string = "",
	line: int = lexer.line,
	col: int = lexer.col,
) {
	append(&chisa.tokens, Token{type = type, lexeme = lexeme, line = line, col = col})
}

tokenize :: proc(source_code: string) -> bool {
	lexer.source_code = source_code
	lexer.source_len = len(source_code)

	for lexer.current < lexer.source_len {
		switch lexer.source_code[lexer.current] {
		case '\n':
			lexer.line += 1
			lexer.col = 1
			break
		case '\t', '\r', ' ':
			break
		case ';':
			add_token(TokenType.Semicolon, ";")
			break
		case '{':
			add_token(TokenType.LeftBrace, "{")
			break
		case '}':
			add_token(TokenType.RightBrace, "}")
			break
		case '(':
			add_token(TokenType.LeftParen, "(")
			break
		case ')':
			add_token(TokenType.RightParen, ")")
			break
		case '[':
			add_token(TokenType.LeftBracket, "[")
			break
		case ']':
			add_token(TokenType.LeftBracket, "]")
			break
		case '+':
			add_token(TokenType.Plus, "+")
			break
		case '-':
			add_token(TokenType.Minus, "-")
			break
		case '*':
			add_token(TokenType.Star, "*")
			break
		case '%':
			add_token(TokenType.Percent, "%")
			break
		case '^':
			add_token(TokenType.Caret, "^")
			break
		case '/':
			// TODO: Comments
			add_token(TokenType.Slash, "/")
			break
		case '=':
			if source_code[lexer.current + 1] == '=' {
				advance()
				add_token(TokenType.EqualEqual, "==")
			} else {
				add_token(TokenType.Equal, "=")
			}
			break
		case ':':
			if source_code[lexer.current + 1] == ':' {
				advance()
				add_token(TokenType.ColonColon, "::")
			} else {
				add_token(TokenType.Colon, ":")
			}
			break
		// case '"': // String
		// 	break
		case:
			if is_numeric(lexer.source_code[lexer.current]) {
				number()
				continue
			} else if is_alpha(lexer.source_code[lexer.current]) {
				identifier_or_keyword()
				continue
			} else {
				add_token(TokenType.Illegal)
			}
		}
		advance()
	}
	return true
}
