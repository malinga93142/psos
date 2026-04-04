ENTRY(_start)
SECTIONS {
    . = 0x7C00;
    .text : { *(.text) }
    . = ALIGN(4);
    .data : { *(.data) }
    . = ALIGN(4)
    .bss  : { *(.bss) }
}
