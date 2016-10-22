.PHONY: clean image run

OSBIN = src/startup.bin
IMG   = flp144.img

all: clean deps build image run

deps: scripts/BootProg/mkimg144 scripts/BootProg/flp144.bin

scripts/BootProg/flp144.bin: scripts/BootProg
	cd scripts/BootProg && nasm -f bin flp144.asm -o flp144.bin

scripts/BootProg/mkimg144: scripts/BootProg
	cd scripts/BootProg && smlrcc mkimg144.c -o mkimg144

scripts/BootProg:
	mkdir -p scripts
	cd scripts && git clone git@github.com:alexfru/BootProg.git

build: $(OSBIN)

$(OSBIN):
	cd src && make build

image: $(OSBIN)
	./scripts/BootProg/mkimg144 -bs ./scripts/BootProg/flp144.bin -o $(IMG) -us src/STARTUP.BIN

run: $(IMG)
	qemu-system-i386 -fda $(IMG) -m 128

clean:
	rm -f src/main.asm src/startup.bin
