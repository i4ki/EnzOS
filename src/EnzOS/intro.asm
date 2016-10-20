        DRVMSG1 db "Found ", 0
        DRVMSG2 db " disk drives.", 0
        NODRVMSG db "No hard drive installed...", 0

        %include "src/EnzOS/io.asm"

intro:
        pusha
        
        mov dh, 1
        mov dl, 1
        call setcursor

        mov si, NAME
        call printstr

        mov al, ' '
        call printchar

        mov si, VERSION
        call printstr

        mov dh, 4
        mov dl, 10
        call setcursor

        call io_getdrvno

        cmp ax, 0xffff
        jz .noharddrive

        mov si, DRVMSG1
        call printstr

        add al, 48
        call printchar
        
        mov si, DRVMSG2
        call printstr

        mov dl, 80h
        call io_getdrvparams

        xor eax, eax
        mov al, [drv_cylinders]
        inc al                  ; cylinders starts at 0
        add al, 48              ; ascii of 0
        call printchar

        popa
        ret
        
.noharddrive:
        mov si, NODRVMSG
        call printstr
        
        popa
        ret

        
        
