nasm -f elf64 -o syscall.o syscall.asm
x86_64-elf-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c print.c
x86_64-elf-ar rcs lib.a print.o syscall.o

nasm -f elf64 -o start.o start.asm
x86_64-elf-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c main.c
x86_64-elf-ld -nostdlib -T link.lds -o user start.o main.o lib.a 
x86_64-elf-objcopy -O binary user user1.bin

