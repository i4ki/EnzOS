.PHONY: clean

ASMGENFILES = 	main.asm \
		vesa.asm \
		win.asm \
		term.asm \
		libc/str.asm \
		libc/mem.asm \
		libc/stdio.asm

ASMFILES = 	start.asm

CFILES = $(patsubst %.asm,%.c,$(ASMGENFILES))
ENZOS = STARTUP.BIN

all: clean build

build: $(ASMGENFILES) $(ASMFILES)
	smlrcc -doss -small -nobss  $^ -o $(ENZOS)

%.asm: %.c
	smlrc -I ./include -seg16 -nobss $< $@

clean:
	rm -f $(ASMGENFILES) $(ENZOS)
