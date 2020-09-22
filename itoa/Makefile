.PHONY: clean

compile: itoa.nasm
	@mkdir -p out
	@nasm -f elf64 itoa.nasm -o out/itoa.o
	@ld out/itoa.o -o out/itoa

clean:
	@rm -rf out
