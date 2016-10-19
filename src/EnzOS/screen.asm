        WHITE equ 10011111b
        

discursor:
        pusha

        xor ax, ax
        mov ah, 01h
        mov ch, 28h
        mov cl, 09h
        int 10h

        popa
        ret



        
