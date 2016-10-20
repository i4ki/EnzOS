	;;--------------------------------------
	;;    EnzOS bootloader
	;;--------------------------------------
	[BITS 16]
        [ORG 0x7c00] 

	jmp start; skip data

	;;         some data
 gdtinfo:
        dw gdt_end - gdt - 1   ;last byte in table
        dd gdt                 ;start of table
 
        gdt         dd 0,0        ; entry 0 is always unused
        flatdesc    db 0xff, 0xff, 0, 0, 0, 10010010b, 11001111b, 0
gdt_end:
        
	BOOTDRV    db 0
	DRVNO      db 0
	NERRORS    db 0
	BANNER     db "EnzOS bootloader v0.0.1", 0
	LOADMSG    db "Loading EnzOS...", 0
	REBOOTMSG  db "Something wrong... Press any key to reboot.", 0
	ETRYAGAIN  db "Error reading disk... try again.", 13, 10, 0
	ENZOSMAGIC db 1, 3, 3, 7

        ENZOS_SEGMENT equ 0500h
        ENZOS_SKIPHDR equ 0004h

	;; common routines

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
	mov [BOOTDRV], dl; save the drive we booted from

        xor ax, ax
        mov ds, ax

	;;  Setup the stack
	cli ; cli required, because BIOS could update sp
	mov ax, 0x07e0
	mov ss, ax
	mov sp, 0xffff; whole segment, 64Kib of stack

        ;; Setup Unreal Mode
        ;; Enables 4GB addressing with 32-bit registers
        ;; Code segment is still limited to 64Kib
        ;; http://wiki.osdev.org/Unreal_Mode
        ;; The code below enter protected mode mode, setup
        ;; gdt and go back to real mode
        push ds                ; save real mode

        lgdt [gdtinfo]         ; load gdt register
 
        mov  eax, cr0          ; switch to pmode by
        or al,1                ; set pmode bit
        mov  cr0, eax
 
        jmp $+2                ; tell 386/486 to not crash
 
        mov  bx, 0x08          ; select descriptor 1
        mov  ds, bx            ; 8h = 1000b
 
        and al,0xFE            ; back to realmode
        mov  cr0, eax          ; by toggling bit again
 
        pop ds                 ; get back old segment
        sti

	xor  dx, dx; pos 0, 0
	call setcursor

	mov  si, BANNER
	call printstr

	mov  dl, 0
	mov  dh, 1; newline
	call setcursor

	mov  si, LOADMSG
	call printstr

	jmp loadEnzOS

errLoading:
	mov  si, ETRYAGAIN
	call printstr

	mov bl, NERRORS
	add bl, 1
	test bl, 3
	jz  reboot

	mov [NERRORS], bl

loadEnzOS:
	;   reset the disk controller
	xor ax, ax
	int 0x13
	jc  reboot

	;;  Load EnzOS above the stack (0x9000:0000)
	mov word ax, ENZOS_SEGMENT
	mov es, ax
	xor bx, bx

	;;  ah = 02  -> read disk sectors
	;;  al = ??? -> number of sectors
	mov ah, 2
	mov al, LOADNSECTORS; this value must be passed as macro (-D)
	;;  set start CHS
	mov ch, 0; cylinder = 0
	mov cl, 2; sector = 2
	mov dh, 0; head = 0
	mov dl, [BOOTDRV]; disk = what we booted from
	int 0x13
	jc  errLoading

	;;  Check if we have a valid super block
	;;  ES points to 0x9000
	mov di, 0; offset of EnzOS magic signature
	mov si, ENZOSMAGIC
	cmpsw
	jnz reboot

	;   set A20 line
	cli
	xor cx, cx

clear_buf:
	in     al, 64h; get input from keyboard status port
	test   al, 02h; test the buffer full flag
	loopnz clear_buf; loop until buffer is empty
	mov    al, 0D1h; keyboard: write to output port
	out    64h, al; output command to keyboard

clear_buf2:
	in     al, 64h; wait 'till buffer is empty again
	test   al, 02h
	loopnz clear_buf2
	mov    al, 0dfh; keyboard: set A20
	out    60h, al; send it to the keyboard controller
	mov    cx, 14h
	wait_kbc:                       ; this is approx. a 25uS delay to wait
	out    0edh, ax; for the kb controler to execute our
	loop   wait_kbc; command.

end:
	jmp ENZOS_SEGMENT:ENZOS_SKIPHDR

