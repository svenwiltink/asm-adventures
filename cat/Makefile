.PHONY: clean

compile: cat.asm
	@mkdir -p out
	@nasm -f elf64 cat.asm -o out/cat.o
	@ld out/cat.o -o out/cat

clean:
	@rm -rf out
