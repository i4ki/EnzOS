	;; Entrypoint of EnzOS
	;; This is the first code executed, the bootloader catapulted us here
	;; at physical address 0x9000 in real mode and A20 address line set.
	;; Set segment registers, stack and then call C!

	[BITS 16]
	[ORG  0]

        %define ENZOS_ADDR 0x2000

	MAGIC db 1, 3, 3, 7

	jmp start

	%include "common.asm"
        %include "main.asm"

start:
        mov ax, ENZOS_ADDR
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

        call main
