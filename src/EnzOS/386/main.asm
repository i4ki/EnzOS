        ;; Main program

       	BANNER    db "Welcome to EnzOS :: A learning tool for OS Design", 0
	AUTHORS   db "Authors: i4k & katz", 0
	REBOOTMSG db "Press any key to reboot...", 13, 10, 0

        ;; draw left buffer variables
        pcounter dw 0

reboot:
	mov  si, REBOOTMSG
	call printstr
	call getkey

	db 0EAh; harcode jump to FFFF:0000 (reboot)
	dw 0000h
	dw 0FFFFh
	;; bye bye

draw_mainwindow:        
        pusha

        call discursor

        ;; pos at 0,0
        mov dl, 0
        mov dh, 0
        call setcursor

        mov ah, 09h
        mov bh, 0
        mov cx, 1
        mov bl, 10011111b
        mov al, 201             ; top-left corner ascii
        int 10h

        mov dl, 1
        mov dh, 0
        call setcursor

        mov ah, 09h
        mov bh, 0
        mov cx, 78
        mov bl, 10011111b
        mov al, 205             ;put '====='...
        int 10h

        mov dl, 79
        mov dh, 0
        call setcursor

        mov ah, 09h
        mov bh, 0
        mov cx, 1
        mov bl, 10011111b
        mov al, 187             ; top-right corner ascii
        int 10h

        mov word [pcounter], 1

.nexrow: 
        cmp word [pcounter], 23
        je .nextline

        mov ah, 09h
        mov bh, 0
        mov cx, 1
        mov bl, 10011111b
        mov al, 186             ; left horizontal line
        int 10h

        mov dh, 1
        mov dl, 1
        call setcursor

        mov ah, 09h
	mov cx, 78
        mov bx, 10011111b
	mov bh, 0
	mov al, ' '
	int 10h

        mov dh, 1
        mov dl, 79
        call setcursor

        mov ah, 09h
        mov bh, 0
        mov cx, 1
        mov bl, 10011111b
        mov al, 186
        int 10h

        inc word [pcounter]
        jmp .nexrow

.nextline:
        popa
        ret
        
        
                ;; Draw the main window
        ;; INPUT: AX
draw_window:
	pusha

	push ax				; Store params to pop out later
	push bx
	push cx

	mov dl, 0
	mov dh, 0
	call setcursor

	mov ah, 09h			; Draw white bar at top
	mov bh, 0
	mov cx, 80
	mov bl, 01110000b
	mov al, ' '
	int 10h

	mov dh, 1
	mov dl, 0
	call setcursor

	mov ah, 09h			; Draw colour section
	mov cx, 1840
	pop bx				; Get colour param (originally in CX)
	mov bh, 0
	mov al, ' '
	int 10h

	mov dh, 24
	mov dl, 0
	call setcursor

	mov ah, 09h			; Draw white bar at bottom
	mov bh, 0
	mov cx, 80
	mov bl, 01110000b
	mov al, ' '
	int 10h

	mov dh, 24
	mov dl, 1
	call setcursor
	pop bx				; Get bottom string param
	mov si, bx
	call printstr

	mov dh, 0
	mov dl, 1
	call setcursor
	pop ax				; Get top string param
	mov si, ax
	call printstr

	mov dh, 1			; Ready for app text
	mov dl, 0
	call setcursor

	popa
	ret
        
main:
        ;; set to bright text output
        call clearscreen

        call draw_mainwindow

	jmp $
