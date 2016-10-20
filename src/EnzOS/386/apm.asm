        ;; APM functions

        APMERRMSG db "Error when checking APM...", 13, 10, 0
        APMMSG1   db "APM ", 0
        APMMSG2   db " Found.", 13, 10, 0
        APMVER    db 0, 0, 0, 0
        
apm_install_check:
        ;perform an installation check
        mov ah,53h            ; APM command
        mov al,00h            ; installation check command
        xor bx,bx             ; device id (0 = APM BIOS)
        int 15h
        jc apm_error

        mov si, APMMSG1
        call printstr

        mov dl, ah
        add dl, 48
        mov [APMVER], dl

        mov byte [APMVER+1], '.'

        mov dl, al
        add dl, 48
        mov [APMVER+2], dl

        mov si, APMVER
        call printstr

        mov si, APMMSG2
        call printstr

        ret

apm_error:      
        mov si, APMERRMSG
        call printstr

        jmp reboot

apm_connect:
        ;connect to an APM interface
        mov ah, 53h
        mov al, 01h
        xor bx,bx                ;device id (0 = APM BIOS)
        int 15h
        jc apm_error

        ret

apm_enable_all:
        ;Enable power management for all devices
        mov ah,53h
        mov al,08h              ;Change the state of power management...
        mov bx,0001h            ;...on all devices to...
        mov cx,0001h            ;...power management on.
        int 15h                 ;call the BIOS function through interrupt 15h
        jc apm_error

        ret

apm_shutdown:
        ;; shutdown all devices
        mov ah,53h
        mov al,07h              ;Set the power state...
        mov bx,0001h            ;...on all devices to...
        mov cx,POWERSTATE_OFF
        int 15h
        jc apm_error

        ret
