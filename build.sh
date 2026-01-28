# 1. Assemble Assembly Files
nasm -f bin -o boot.bin boot.asm
nasm -f bin -o loader.bin loader.asm
nasm -f elf64 -o kernel.o kernel.asm
nasm -f elf64 -o trapa.o trap.asm   # New: Assemble trap.asm to trapa.o

# 2. Compile C Files
# We use x86_64-elf-gcc for your Mac
x86_64-elf-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c main.c -o main.o
x86_64-elf-gcc -std=c99 -mcmodel=large -ffreestanding -fno-stack-protector -mno-red-zone -c trap.c -o trap.o

# 3. Link Everything
# We link kernel.o, main.o, trapa.o (assembly traps), and trap.o (C handler)
x86_64-elf-ld -nostdlib -T link.lds -o kernel kernel.o main.o trapa.o trap.o

# 4. Extract Raw Binary
x86_64-elf-objcopy -O binary kernel kernel.bin 

# 5. Write to Disk Image
dd if=boot.bin of=boot.img bs=512 count=1 conv=notrunc
dd if=loader.bin of=boot.img bs=512 count=5 seek=1 conv=notrunc
dd if=kernel.bin of=boot.img bs=512 count=100 seek=6 conv=notrunc