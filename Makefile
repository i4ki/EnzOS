all: build

build:
	./make.sh

test:
	./make.sh test

debug:
	./make.sh debug-start-vm

gdb:
	./make.sh debug-gdb
