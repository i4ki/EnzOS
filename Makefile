AS := nasm
ASFLAGS := -fbin

SRC_ASM = $(patsubst %.asm,%.386,$(wildcard src/386/*.asm))

TARGET = EnzOS.386
DISKIMG = disk.raw

all: $(TARGET)
	@echo "OS built successfully"

$(TARGET): $(SRC_ASM)
	cp $^ $@

%.386: %.asm
	$(AS) $(ASFLAGS) -o "$@" "$^"

image: $(TARGET)
	rm -f disk.raw
	dd if=/dev/zero of=$(DISKIMG) bs=1M count=8
	$(GOPATH)/bin/fdisk mbr -create -bootcode $^ $(DISKIMG)

run: image
	qemu-system-x86_64 -hda $(DISKIMG) -m 256

clean:
	rm -f $(SRC_ASM) $(TARGET) $(DISKIMG)
