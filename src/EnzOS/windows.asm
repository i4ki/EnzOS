        ;; TUI

        %include "src/EnzOS/screen.asm"

        ;; draw left buffer variables
        pcounter dw 0,


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
        mov bl, WHITE
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
        cmp word [pcounter], 24
        je .end

        mov dl, 0
        mov dh, [pcounter]
        call setcursor

        mov ah, 09h
        mov bh, 0
        mov cx, 1
        mov bl, 10011111b
        mov al, 186             ; left vertical line
        int 10h

        mov dh, [pcounter]
        inc dl
        call setcursor

        mov ah, 09h
	mov cx, 78
        mov bx, 10011111b
	mov bh, 0
	mov al, ' '
	int 10h

        mov dh, [pcounter]
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

.end:
        mov dh, 24
        mov dl, 0
        call setcursor

        mov ah, 09h
        mov bh, 0
        mov cx, 1
        mov bl, WHITE
        mov al, 200             ; bottom-left corner ascii
        int 10h

        mov dl, 1
        mov dh, 24
        call setcursor

        mov ah, 09h
        mov bh, 0
        mov cx, 78
        mov bl, 10011111b
        mov al, 205             ;put '====='...
        int 10h

        mov dl, 79
        mov dh, 24
        call setcursor

        mov ah, 09h
        mov bh, 0
        mov cx, 1
        mov bl, 10011111b
        mov al, 188             ; bottom-right corner ascii
        int 10h
        popa
        ret
