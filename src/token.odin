package chisa

TokenType :: enum {
	Illegal,
	LeftBrace,
	RightBrace,
	LeftBracket,
	RightBracket,
	LeftParen,
	RightParen,
	Colon,
	ColonColon,
}

Token :: struct {
	type:   TokenType,
	lexeme: string,
	line:   int,
	col:    int,
}
