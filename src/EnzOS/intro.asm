        DRVMSG1 db "Found ", 0
        DRVMSG2 db " drives.", 0
        NODRVMSG db "No hard drive installed...", 0

        %include "src/EnzOS/io.asm"

intro:
        pusha
        
        mov dh, 1
        mov dl, 1
        call setcursor

        mov si, NAME
        call printstr

        push byte ' '
        mov si, sp
        call printchar

        mov si, VERSION
        call printstr

;;         mov dh, 10
;;         mov dl, 20
;;         call setcursor

;;         call io_getdrvno

;;         cmp ax, 0xffff
;;         jz .noharddrive

;;         mov si, DRVMSG1
;;         call printstr

;;         add al, 48
;;         push ax
;;         mov si, sp
;;         call printchar
        
;;         mov si, DRVMSG2
;;         call printstr
        
;; .noharddrive:
;;         mov si, NODRVMSG
;;         call printstr
        
        popa
        ret

        
        
