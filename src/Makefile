build:
	smlrc -I ./include/ -seg16 -nobss main.c main.asm
	smlrc -I ./include/ -seg16 -nobss vesa.c vesa.asm
	smlrcc -doss -small -nobss start.asm main.asm vesa.asm -o startup.bin
