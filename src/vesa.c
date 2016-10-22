#include "EnzOS/types.h"
#include "EnzOS/libc.h"
#include "EnzOS/vesa.h"

typedef struct
{
        uint8 Signature[4];         // 'VESA' VBE Signature
        uint16 Version;             // 0300h VBE Version
        uint16 OemStringPtr1[2];    // VbeFarPtr to OEM String
        uint8 Capabilities[4];      // Capabilities of graphics controller
        uint16 VideoModePtr[2];     // VbeFarPtr to VideoModeList
        uint16 TotalMemory;         // Number of 64kb memory blocks

        // Added for VBE 2.0+
        uint16 OemSoftwareRev;      // VBE implementation Software revision
        uint16 OemVendorNamePtr[2]; // VbeFarPtr to Vendor Name String
        uint16 OemProductNamePtr[2];// VbeFarPtr to Product Name String
        uint16 OemProductRevPtr[2]; // VbeFarPtr to Product Revision String
        uint8 Reserved[222];        // Reserved for VBE implementation scratch
        // area
        uint8 OemData[256];         // Data Area for OEM Strings
} VbeInfo;

void setVGAMode(unsigned mode)
{
        asm("mov ah, 0\n"
            "mov al, [bp + 4]\n"
            "int 0x10");
}

int getVbeInfo(VbeInfo *info) {
        asm("mov ah, 4fh\n"
            "mov al, 0\n"
            "mov bx, ds\n"
            "mov es, bx\n"
            "mov di, [bp+4]\n"
            "int 10h");
}

void vesaInit() {
        VbeInfo vbe;
        char version[4];
        char name[5];
        int err;

        // Get and check VBE info

        if ((err = getVbeInfo(&vbe)) != 0x4F) {
                printf("GetVbeInfo() failed: ");
                return;
        }
}

void poke(uint16 seg, uint16 ofs, unsigned val)
{
  asm("push ds\n"
      "mov  ds, [bp + 4]\n"
      "mov  bx, [bp + 6]\n"
      "mov  ax, [bp + 8]\n"
      "mov  [bx], ax\n"
      "pop  ds");
}

uint16 putn(uint8 x, uint8 y, char *s, uint16 sz, unsigned color) {
        uint16 i = 0;
        uint16 ofs = (y * VWIDTH + x) * 2;

        for (i = 0; i < sz; i++) {
                uint16 v = (color << 8) | s[i];
                poke(VSEG, ofs, v);
                ofs += 2;
        }

        return i;
}

uint16 putstr(uint8 x, uint8 y, char *s, uint8 color)
{
        return putn(x, y, s, strlen(s), color);
}

void putchar(unsigned x, unsigned y, char c, unsigned color) {
        uint16 offset = (y * VWIDTH + x) * 2;
        unsigned v = (color << 8) | c;
        poke(VSEG, offset, v);
}
