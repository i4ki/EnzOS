# EnzOS

Operating system for operating system writers.

## Introduction

The idea of EnzOS is build a basic real-mode operating system as a
tool and IDE to create another operating system.

The main goal is develop a very old-fashioned assembly IDE, that can
build and test the code on real hardware instantly. The system could
be used for:

 - Test new ideas on OS development very fast;
 - Teach or learn assembly and operating systems design;
 - Create a bootloader;
 - Create an assembly driver for a gadget/device;
 - Have fun!

## UX Design

When booted, the system must probe the BIOS for available disk devices
and ask the user to select the desired location to read or store the source
code. The user must select a device, and then a partition.

    +---------------------------------------------------------+
    | EnzOS v0.0.1                                            |
    | Authors: i4k & katz                                     |
    |                                                         |
    | Probing disk devices... Found 2                         |
    |                                                         |
    | Please select the location of source code:              |
    |  * WD342112TX 500GB                                     |
    |    - p1 100GB ext3   <-                                 |
    |    - p2 30GB fat                                        |
    |  * ADATA 8GB                                            |
    |                                                         |
    +---------------------------------------------------------+

Then, the system must open a menu to user select the file or create a
new one on a specified directory. 

Example file selection from MikeOS:

![select file](http://i.stack.imgur.com/mr8H2.png)

After that, the assembler IDE will
show up.

    +---------------------------------------------------------+
    | Save (C-s) | Open (C-o) | Assemble (C-c) | Test (C-x)   |
    +---------------------------------------------------------+
    |  Install   | Show info (C-h)| Reset (C-r)| Shutdown     |
    +---------------------------------------------------------+
    |        ;;; Example operating system                     |
    |start:                                                   |
    |        mov ah, 2     ;; set cursor position             |
    |        mov dh, 3     ;; move to row 3                   |
    |        mov dl, 14    ;; column 14                       |
    |        int 10h       ;; BIOS Video service call         |
    |                                                         |
    |        dd 0xdeadbeef ;; invalid opcode will return      |
    |                      ;; the control to the IDE          |
    |                                                         |
    |                                                         |
    |                                                         |
    |                                                         |
    |                                                         |
    +---------------------------------------------------------+
    | Assembler output:                                       |
    | Built successfully at memory address 0x1000-0x11ff      |
    +---------------------------------------------------------+
    | Processor: Intel(R) Core(TM) i3-3217U (Real mode)       |
    | Memory: 4GB  Used: 300KB                                |
    +---------------------------------------------------------+

When pressed C-c the system must assemble the file in-memory and when
pressed C-x the system must prepare the processor and jump to
assembled location as if it had been executed by BIOS (no reboot).

The system must have the IVT (Interrupt Vector Table) configured to
handle invalid opcode exceptions.

The user developed operating system could take full control of the
machine, remapping IVT, enter protected mode, set GDT, ISR, etc, and
reuse EnzOS memory. But in this case, it'll require a reboot to get
into IDE again.

## Implementation notes

- Because of the assembler and fs, the OS must be written in C.
- There's no requirement to write it in real mode. It's only the most
  easy way... (using the BIOS). We can write it to protected mode, and
  fallback to real mode to execute the user code.
