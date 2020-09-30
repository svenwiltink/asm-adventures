.PHONY: clean

compile: itoa.nasm strings.nasm
	@mkdir -p out
	@nasm -f elf64 itoa.nasm -o out/itoa.o
	@nasm -f elf64 strings.nasm -o out/strings.o
	@ld out/itoa.o out/strings.o -o out/itoa

clean:
	@rm -rf out
