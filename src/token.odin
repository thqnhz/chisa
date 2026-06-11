package chisa

TokenType :: enum {
	Illegal,
	// Puncuations
	LeftBrace,
	RightBrace,
	LeftBracket,
	RightBracket,
	LeftParen,
	RightParen,
	Colon,
	ColonColon,
	Semicolon,
	// Arithmetic
	Plus,
	Minus,
	Star,
	Slash,
	Percent,
	Caret,
	Equal,
	EqualEqual,
	// Literals & Identifier
	Identifier,
	IntLiteral,
	FloatLiteral,
	StringLiteral,
	True,
	False,
	// Types
	IntType,
	FloatType,
	StringType,
	BoolType,
	// Keywords
	Let,
}

Token :: struct {
	type:   TokenType,
	lexeme: string,
	line:   int,
	col:    int,
}
