discursor:
        pusha

        xor ax, ax
        mov ah, 01h
        mov ch, 28h
        mov cl, 09h
        int 10h

        popa
        ret

setcursor:
	pusha
	xor ax, ax
	mov ah, 2
	int 10h
	popa
	ret

clearscreen:
	pusha
	mov ax, 0x0600; clear the "window"
	mov cx, 0x0000; from (0, 0)
	mov dx, 0x184f; to (24, 79)
	mov bh, 0x07; keep light grey display
	int 0x10
	popa
	ret

printchar:
	pusha
	;;  character in SI
	mov ah, 0Eh
	lodsb
	int 10h
	popa
	ret

printstr:
	;;  null-terminated string in SI
	pusha
	mov ah, 0Eh; INT 10h teletype.

.loop:
	lodsb
	cmp al, 0; Null terminator reached?
	je  .done

	int 10h
	jmp .loop

.done:
	popa
	ret

getkey:
	mov ah, 0; wait for key
	int 16h
	ret

getdrvno:
	;;  no input
	;;  Return number of drives in register dl
	;;  In case of error, dl will have 0xff
	xor dx, dx

	mov dl, 80h; tell bios to look at hard drives
	mov ah, 8h; set command to get drive parameter
	int 13h; call BIOS to get number of drives

	jc .noharddrive

	ret

.noharddrive:
	mov dl, 0xff
	ret
