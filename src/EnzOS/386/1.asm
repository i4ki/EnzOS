	;; Entrypoint of EnzOS
	;; This is the first code executed, the bootloader catapulted us here
	;; at physical address 0x9000 in real mode and A20 address line set.
	;; Set segment registers, stack and then call C!

	[BITS 16]
	[ORG  0]

	MAGIC db 1, 3, 3, 7

	jmp start

	BANNER    db "Welcome to EnzOS", 13, 10, 0
	AUTHORS   db "Authors: i4k & katz", 13, 10, 0
	REBOOTMSG db "Press any key to reboot...", 13, 10, 0

	%include "common.asm"

reboot:
	mov  si, REBOOTMSG
	call printstr
	call getkey

	db 0EAh; harcode jump to FFFF:0000 (reboot)
	dw 0000h
	dw 0FFFFh
	;; bye bye

start:
	mov ax, 0x9000
	mov ds, ax; Set ds to easy access data

	call clearscreen

	mov  si, BANNER
	call printstr
	mov  si, AUTHORS
	call printstr

	jmp reboot
