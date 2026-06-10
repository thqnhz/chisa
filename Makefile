PROG_NAME := Chisa

.PHONY: build

all: build

build: src/*.odin
	mkdir -p build
	odin build src -out:build/$(PROG_NAME)

%:
	@:
