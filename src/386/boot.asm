	[BITS 16]
	[ORG  0x7C00]

        mov esp, stack_top

        call clearscreen

        xor dx, dx      ; pos 0, 0
        call setcursor

        mov si, BANNER
        call printstr

        mov dl, 0
        mov dh, 1       ; newline
        call setcursor

        xor dx, dx

        mov dl, 80h     ; tell bios to look at hard drives 
        mov ah, 8h      ; set command to get drive parameter 
        int 13h         ; call BIOS to get number of drives

        jc noharddrive

        mov si, HDDMSG1
        call printstr

        add dl, 48
        push dx
        mov si, sp
        call printchar
        
        mov si, HDDMSG2
        call printstr

        call end
        
noharddrive:
        mov si, NOHDDMSG
        call printstr

end:    
        JMP $; infinite loop

setcursor:
        pusha
        xor ax, ax
	mov ah, 2
	int 10h
        popa
        ret

clearscreen:
	pusha
	mov ax,0x0600	; clear the "window"
	mov cx,0x0000   ; from (0,0)
	mov dx,0x184f	; to (24,79)
	mov bh,0x07	; keep light grey display
	int 0x10
	popa
	ret

printchar:
        pusha
        ;; character in SI
        mov ah, 0Eh
        lodsb
        int 10h
        popa
        ret
        
printstr:
        ;; null-terminated string in SI
        pusha
        mov ah, 0Eh    ; INT 10h teletype.
 
.loop:
        lodsb
        cmp al, 0    ; Null terminator reached?
        je .done
 
        int 10h
        jmp .loop
 
.done:
        popa
        ret

;;; set up a little stack
stack_bottom: times 50 db 0
stack_top:

BANNER:         db "EnzOS bootloader v0.0.1", 0
HDDMSG1:        db "Found ", 0
HDDMSG2:        db " hard drives.", 0
NOHDDMSG:       db "error: No HDD installed", 0
