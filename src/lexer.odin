package chisa

Lexer :: struct {
	current: int,
	line:    int,
	col:     int,
}

lexer := Lexer {
	current = 0,
	line    = 1,
	col     = 1,
}

// Create a token under the current line and column
make_token :: proc(type: TokenType, lexeme: string = "") -> Token {
	return Token{type = type, lexeme = lexeme, line = lexer.line, col = lexer.col}
}

tokenize :: proc(chisa: ^Chisa, source_code: string) -> bool {
	for lexer.current < len(source_code) {
		switch source_code[lexer.current] {
		case '\n', '\r':
			lexer.line += 1
			lexer.col = 1
			break
		case '\t', ' ':
			lexer.col += 1
			break
		case ':':
			if source_code[lexer.current + 1] == ':' {
				append(&chisa.tokens, make_token(TokenType.ColonColon, "::"))
				lexer.col += 1
				lexer.current += 1
			} else {
				append(&chisa.tokens, make_token(TokenType.Colon, ":"))
			}
			lexer.col += 1
			break
		case '{':
			append(&chisa.tokens, make_token(TokenType.LeftBrace, "{"))
			lexer.col += 1
			break
		case '}':
			append(&chisa.tokens, make_token(TokenType.RightBrace, "}"))
			lexer.col += 1
			break
		case '(':
			append(&chisa.tokens, make_token(TokenType.LeftParen, "("))
			lexer.col += 1
			break
		case ')':
			append(&chisa.tokens, make_token(TokenType.RightParen, ")"))
			lexer.col += 1
			break
		case '[':
			append(&chisa.tokens, make_token(TokenType.LeftBracket, "["))
			lexer.col += 1
			break
		case ']':
			append(&chisa.tokens, make_token(TokenType.LeftBracket, "]"))
			lexer.col += 1
			break
		case:
			// append(&chisa.tokens, make_token(&lexer, TokenType.Illegal))
			lexer.col += 1
			break
		}
		lexer.current += 1
	}
	return true
}
