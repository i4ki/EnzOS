        ;; IO routines

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

        mov [.drvno], dx
        jmp .end

.noharddrive:
        mov word [.drvno], 0xffff
.end:
        popa
        mov ax, [.drvno]
	ret

        .drvno dw 0
