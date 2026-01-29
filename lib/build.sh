nasm -f elf64 -o syscall.o syscall.asm
x86_64-elf-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c print.c
x86_64-elf-ar rcs lib.a print.o syscall.o