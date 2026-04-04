.intel_syntax noprefix

# ── Stage 1 Bootloader ──────────────────────────────────────────────
# Loads sector 2 into 0x7E00, sets up GDT, enters protected mode,
# and calls kmain32.
# ────────────────────────────────────────────────────────────────────

.code16
.text
.globl _start
_start:
		cli

		# load sector 2 into 0x7E00
		xor ax, ax
		mov es, ax
		mov ah, 0x02
		mov al, 1
		mov ch, 0
		mov cl, 2
		mov dh, 0
		mov dl, 0x80
		mov bx, 0x7E00
		int 0x13
    jc disk_err
		xor ax, ax
		mov ds, ax
		mov ss, ax
		mov sp, 0x7c00

		lgdt [gdt_desc]
		mov eax, cr0
		or eax, 1
		mov cr0, eax
		ljmp 0x08, offset pmode

# ── Protected Mode ───────────────────────────────────────────────────
.code32
.extern kmain32
pmode:
		mov ax, 0x10
		mov ss, ax
		mov ds, ax
		mov es, ax
		mov fs, ax
		mov gs, ax
		mov esp, 0x90000
		call kmain32
hang:
		hlt
		jmp hang
disk_err:
    mov al, 'E'
    mov ah, 0x0e
    int 0x10
    jmp hang
# ── GDT ──────────────────────────────────────────────────────────────
.align 8
gdt_start:
		.quad 0x0000000000000000
		.quad 0x00CF9A000000FFFF
		.quad 0x00CF92000000FFFF
gdt_end:
gdt_desc:
		.word gdt_end - gdt_start - 1
		.long gdt_start

.org 510
.byte 0x55, 0xAA

