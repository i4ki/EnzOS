        ;; IO routines

        ERRDRVPARAMS db "Failed to read driver parameters", 13, 10, 0

        drvno dw 0

drvParams:      
        drv_size        dw 0
        drv_flags       dw 0
        drv_cylinders   dd 0
        drv_heads       dd 0
        drv_spt         dd 0
        drv_nsectors    times 2 dd 0
        drv_bs          dw 0
        drv_edd         dd 0
        
;;; Get number of hard drives and return in AX
io_getdrvno:
        pusha
        
	;;  no input
	;;  Return number of drives in register dl
	;;  In case of error, dl will have 0xff
	xor dx, dx

	mov dl, 80h; tell bios to look at hard drives
	mov ah, 8h; set command to get drive parameter
	int 13h; call BIOS to get number of drives

	jc .noharddrive

        mov [drvno], dx
        jmp .end

.noharddrive:
        mov word [drvno], 0xffff
.end:
        popa
        mov ax, [drvno]
	ret

_io_zerodrvparams:
        pusha
        xor eax, eax
        mov [drv_size], ax
        mov [drv_flags], ax
        mov [drv_cylinders], eax
        mov [drv_heads], eax
        mov [drv_spt], eax
        mov [drv_nsectors], eax
        mov [drv_nsectors+4], eax
        mov [drv_bs], ax
        mov [drv_edd], ax
        popa
        ret

io_getdrvparams:
        pusha

        call _io_zerodrvparams

        xor ax, ax
        mov ah, 48h
        mov si, drvParams
        int 13h

        jnc .end
.err:
        push ax
        mov si, ERRDRVPARAMS
        call printstr

        mov al, ' '
        call printchar

        pop ax
        mov al, ah
        xor ah, ah
        add al, 48
        call printchar
.end:
        
        popa
        ret
