	;; Entrypoint of EnzOS
	;; This is the first code executed, the bootloader catapulted us here
	;; at physical address 0x5000 in real mode and A20 address line set.
	;; Set segment registers, stack and then call C!

	[BITS 16]
	[ORG  0]

	MAGIC db 1, 3, 3, 7
        
	jmp main

        %include "src/EnzOS/constants.inc"

	%include "src/EnzOS/common.asm"
        %include "src/EnzOS/apm.asm"
        %include "src/EnzOS/windows.asm"

        ;; screens
        %include "src/EnzOS/intro.asm"


reboot:
	mov  si, REBOOTMSG
	call printstr
	call getkey

	db 0EAh; hardcode jump to FFFF:0000 (reboot)
	dw 0000h
	dw 0FFFFh
	;; bye bye

main:
        mov ax, 0x0500
	mov ds, ax; Set ds to easy access data
        mov gs, ax
        mov fs, ax
        mov es, ax

        cli
        mov ax, 0x0800
        mov ss, ax
        mov sp, 0xffff
        sti
        
        call apm_install_check
        call apm_connect
        call apm_enable_all

        call clearscreen
        call draw_mainwindow
        call intro

        jmp $


        
