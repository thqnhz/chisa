package chisa

import "core:fmt"
import "core:os"

usage :: proc(prog: string) {
	fmt.printfln(`
Chisa Programming language.


Usage: %s <path/to/file.chisa>
		`, prog)
}

main :: proc() {
	if len(os.args) < 2 {
		usage(os.args[0])
		os.exit(1)
	}

	// TODO: Change this
	// NOTE: Let the source path be the second argument for now
	source_path := os.args[1]
	if !os.exists(source_path) {
		fmt.eprintfln("File %s does not exist", source_path)
		os.exit(2)
	}

	bytes, err := os.read_entire_file(source_path, context.allocator)
	if err != nil {
		fmt.eprintfln("Could not open file %s for reading: %s", source_path, err)
		os.exit(3)
	}
	defer delete(bytes)

	chisa := Chisa {
		tokens = make([dynamic]Token, context.allocator),
	}
	defer delete(chisa.tokens)

	tokenize(&chisa, string(bytes))

	fmt.print(chisa.tokens)
}
