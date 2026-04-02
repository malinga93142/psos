all: kernel.bin
boot.o: boot.S
	as --32 boot.S -o boot.o
kernel.o: kernel.c
	gcc -m32 -ffreestanding -fno-stack-protector -nostdlib -fno-pic -c kernel.c -o kernel.o
kernel.elf: boot.o kernel.o
	ld -m elf_i386 -Tlinker.ld -o kernel.elf boot.o kernel.o
kernel.bin: kernel.elf
	objcopy -O binary kernel.elf kernel.bin

qemu: kernel.bin
	qemu-system-i386 -drive file=kernel.bin,format=raw -serial stdio
qemu-nox: kernel.bin
	qemu-system-i386 -drive file=kernel.bin,format=raw -nographic
clean:
	rm kernel.o kernel.bin boot.o kernel.elf
