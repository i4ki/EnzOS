        ;; Common code between Bootloader and EnzOS
        ;; DO NOT PUT code not shared among loader and OS
        ;; because of the 512 bytes limit.

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
	;;  character in al
	mov ah, 0Eh
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
        pusha
	mov ah, 0; wait for key
	int 16h
        popa
	ret

