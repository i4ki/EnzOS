#include "EnzOS/vesa.h"

typedef unsigned char uint8;
typedef unsigned short uint16;

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
        char str[4];
        int err;
        int sz;

        // Get and check VBE info

        if ((err = getVbeInfo(&vbe)) != 0x4F) {
                sz = put(0, 1, "GetVbeInfo() failed: ", TEXTCOLOR);
                put(0, sz+1, err + '0', TEXTCOLOR);

                return;
        }

        str[0] = (vbe.Version >> 8)+'0';
        str[1] = '.';
        str[2] = (vbe.Version & 0xff) + '0';
        str[3] = 0;

        put(0, 1, vbe.Signature, TEXTCOLOR);
        put(4, 1, " ", TEXTCOLOR);
        put(6, 1, str, TEXTCOLOR);
}

void poke(unsigned seg, unsigned ofs, unsigned val)
{
  asm("push ds\n"
      "mov  ds, [bp + 4]\n"
      "mov  bx, [bp + 6]\n"
      "mov  ax, [bp + 8]\n"
      "mov  [bx], ax\n"
      "pop  ds");
}

int put(unsigned x, unsigned y, char* s, unsigned color)
{
        int i = 0;
        unsigned ofs = (y * VWIDTH + x) * 2;
        while (s[i]) {
                unsigned v = (color << 8) | s[i++];
                poke(VSEG, ofs, v);
                ofs += 2;
        }

        return i;
}
