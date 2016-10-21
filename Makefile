.PHONY: clean image run

OSBIN = src/startup.bin
IMG   = flp144.img

all: clean build image run

build: $(OSBIN)

$(OSBIN):
	cd src && make build

image: $(OSBIN)
	mkimg144 -bs flp144.bin -o $(IMG) -us src/startup.bin

run: $(IMG)
	qemu-system-i386 -fda $(IMG) -m 128

clean:
	rm -f src/main.asm src/startup.bin
