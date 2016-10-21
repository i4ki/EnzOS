#include "EnzOS/vesa.h"

void BiosSetGfxMode(unsigned mode)
{
        asm("mov ah, 0\n"
            "mov al, [bp + 4]\n"
            "int 0x10");
}

void text(unsigned x, unsigned y, char* s, unsigned color)
{
        unsigned ofs = (y * VWIDTH + x) * 2;
        while (*s) {
                unsigned v = (color << 8) | *s++;
                poke(VSEG, ofs, v);
                ofs += 2;
        }
}
