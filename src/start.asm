
        extern _main

        GLOBAL _start

_start:
        mov ax, 0x900
        mov ss, ax
        mov sp, 0xffff
        
        call _main

        hlt
        
