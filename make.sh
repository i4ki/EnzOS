#!/usr/bin/env nash

IFS            = ()
ASFLAGS        = ("-fbin" "-i" "./src/EnzOS/386/")
BOOTLOADER_SRC = (./src/bootloader/386/1.asm)
ENZOS_SRC      = (./src/EnzOS/386/1.asm)
BOOTLOADER_BIN = "bootloader.bin"
ENZOS_BIN      = "EnzOS.bin"
DISKIMG        = "disk.raw"

rm -f $DISKIMG $ENZOS_BIN $BOOTLOADER_BIN

# getnsectors returns the amount of block sectors needed to
# fit the EnzOS
fn getnsectors() {
	sectsz = "0"

	kernelsz <= wc -c $ENZOS_BIN | cut -d " " -f1 | tr -d "\n"
	sectsz   <= -expr $kernelsz "/" 512 | tr -d "\n"

	if $sectsz == "0" {
		sectsz <= expr $sectsz "+" 1 | tr -d "\n"
	} else if $sectsz == "" {
		sectsz <= expr 0 "+" 1 | tr -d "\n"
	}

	return $sectsz
}

fn buildEnzOS() {
	nasm $ASFLAGS -o $ENZOS_BIN $ENZOS_SRC
}

fn buildLoader() {
	-test -f $ENZOS_BIN

	if $status != "0" {
		echo "error: EnzOS must be compiled before the bootloader"

		return
	}

	sectsz <= getnsectors()

	nasm $ASFLAGS "-DLOADNSECTORS="+$sectsz -o $BOOTLOADER_BIN $BOOTLOADER_SRC
}

fn makeDisk() {
	rm -f disk.raw

	sectsz <= getnsectors()

	# add a sector to put mbr
	sectsz <= expr $sectsz "+" 1 | tr -d "\n"

	dd "if=/dev/zero" "of="+$DISKIMG "bs=512" "count="+$sectsz

	# workaround to force use of our fdisk
	p    = $PATH
	PATH = $GOPATH+"/bin"

	setenv PATH

	fdisk mbr -create -bootcode $BOOTLOADER_BIN $DISKIMG

	PATH = $p

	setenv PATH

	codesz    <= wc -c $ENZOS_BIN | cut -d " " -f1 | tr -d "\n"
	remaining <= -expr 512 "-" $codesz
	seek      <= expr 512 "+" $codesz

	dd "if="+$ENZOS_BIN "of="+$DISKIMG "oflag=seek_bytes" "seek=512" "bs="+$codesz "count=1"

	#	dd "if=/dev/zero" "of="+$DISKIMG "seek="+$seek "bs="+$remaining "count=1"
}

buildEnzOS()
buildLoader()
makeDisk()

echo "EnzOS successfully built"

if len($ARGS) == "2" {
	arg = $ARGS[1]

	if $arg == "test" {
		qemu-system-x86_64 -hda $DISKIMG -m 256
	} else if $arg == "debug-start-vm" {
		qemu-system-x86_64 -hda $DISKIMG -m 256 -s -S
	} else if $arg == "debug-gdb" {
		(
			gdb -ex "target remote localhost:1234"
							-ex "set architecture i8086"
							-ex "set disassembly-flavor intel"
							-ex "layout asm"
							-ex "layout regs"
							-ex "break *0x7c00"
							-ex "break *0x7d5c"
							-ex "continue"
		)
	}
}