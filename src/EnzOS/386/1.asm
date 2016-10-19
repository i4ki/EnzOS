	;; Entrypoint of EnzOS
	;; This is the first code executed, the bootloader catapulted us here
	;; at physical address 0x9000 in real mode and A20 address line set.
	;; Set segment registers, stack and then call C!

	[BITS 16]
	[ORG  0]

        POWERSTATE_STANDBY equ 01h
        POWERSTATE_SUSPEND equ 02h
        POWERSTATE_OFF     equ 03h

	MAGIC db 1, 3, 3, 7

        mov ax, 0x0500
	mov ds, ax; Set ds to easy access data
        
	jmp start

	AUTHORS   db "Authors: i4k & katz", 13, 10, 0
	REBOOTMSG db "Press any key to reboot...", 13, 10, 0

	%include "common.asm"
        ;; %include "apm.asm"
        %include "main.asm"

reboot:
	mov  si, REBOOTMSG
	call printstr
	call getkey

	db 0EAh; harcode jump to FFFF:0000 (reboot)
	dw 0000h
	dw 0FFFFh
	;; bye bye

start:
        ;; call apm_install_check
        ;; call apm_connect
        ;; call apm_enable_all



        call _main

        jmp $
        
