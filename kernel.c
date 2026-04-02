#define COM1 0x3F8

static inline void outb(unsigned short port, unsigned char val) {
  __asm__ volatile("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline unsigned char inb(unsigned short port) {
  unsigned char ret;
  __asm__ volatile("inb %1, %0" : "=a"(ret) : "Nd"(port));
  return ret;
}

void com1_init() {
  outb(COM1 + 1, 0x00);
  outb(COM1 + 3, 0x80);
  outb(COM1 + 0, 0x03);
  outb(COM1 + 1, 0x00);
  outb(COM1 + 3, 0x03);
  outb(COM1 + 2, 0xC7);
  outb(COM1 + 4, 0x03);
}

void com1_putc(char c) {
  while (!(inb(COM1 + 5) & 0x20))
    ;
  outb(COM1, c);
}

void com1_puts(const char *s) {
  while (*s)
    com1_putc(*s++);
}

void kmain32() {
  com1_init();
  com1_puts("hello from protected mode\r\n");
  com1_puts("COM1 is working\r\n");
  while (1){
    __asm__ volatile("hlt");
  }
}
