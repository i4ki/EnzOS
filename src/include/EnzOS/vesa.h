#ifndef VESA_H
#define VESA_H

// video mode, video buffer segment and dimensions
#define VMODE   3 // 80x25 color text mode
#define VSEG    0xB800
#define VWIDTH  80
#define VHEIGHT 25

// foreground and background colors
#define FORE_BLACK   0x00
#define FORE_BLUE    0x01
#define FORE_GREEN   0x02
#define FORE_CYAN    0x03
#define FORE_RED     0x04
#define FORE_MAGENTA 0x05
#define FORE_BROWN   0x06
#define FORE_WHITE   0x07
#define FORE_GRAY           0x08
#define FORE_BRIGHT_BLUE    0x09
#define FORE_BRIGHT_GREEN   0x0A
#define FORE_BRIGHT_CYAN    0x0B
#define FORE_BRIGHT_RED     0x0C
#define FORE_BRIGHT_MAGENTA 0x0D
#define FORE_YELLOW         0x0E
#define FORE_BRIGHT_WHITE   0x0F
#define BACK_BLACK   0x00
#define BACK_BLUE    0x10
#define BACK_GREEN   0x20
#define BACK_CYAN    0x30
#define BACK_RED     0x40
#define BACK_MAGENTA 0x50
#define BACK_BROWN   0x60
#define BACK_WHITE   0x70

#define TERMCOLOR (BACK_BLACK | FORE_BRIGHT_WHITE)

#endif
