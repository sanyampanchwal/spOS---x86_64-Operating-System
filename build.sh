# 1. Assemble Assembly Files
nasm -f bin -o boot.bin boot.asm
nasm -f bin -o loader.bin loader.asm
nasm -f elf64 -o kernel.o kernel.asm
nasm -f elf64 -o trapa.o trap.asm
nasm -f elf64 -o liba.o lib.asm

# 2. Compile C Files
x86_64-elf-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c main.c -o main.o
x86_64-elf-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c trap.c -o trap.o
x86_64-elf-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c print.c -o print.o
x86_64-elf-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c debug.c -o debug.o
x86_64-elf-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c memory.c -o memory.o

# 3. Link Everything
x86_64-elf-ld -nostdlib -T link.lds -o kernel kernel.o main.o trapa.o trap.o liba.o print.o debug.o memory.o

# 4. Extract Binary
x86_64-elf-objcopy -O binary kernel kernel.bin 

# 5. Write to Disk Image
dd if=boot.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
dd if=kernel.bin of=boot.img bs=512 count=100 seek=6 conv=notrunc