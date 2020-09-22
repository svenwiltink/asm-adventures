.PHONY: clean

compile: cat.nasm
	@mkdir -p out
	@nasm -f elf64 cat.nasm -o out/cat.o
	@ld out/cat.o -o out/cat

clean:
	@rm -rf out
