
# ANTY *AJEK COPY

## The Story

This is a file copying program for Atari 8-bit computers, designed to read files protected with the "Speedy 2700 Turbo Loader." Speedy 2700 is a format used to store files in a copy-protected way, compatible with the "Turbo 2000" system. Back in the 1990s, it was commonly used by traders of so-called "pirate software"—they often sold tapes with games and other programs protected using Speedy 2700. In their view, it served as a safeguard to limit competition.

As a young person unwilling to accept such practices, I decided to write a program that would reverse-engineer Speedy 2700, allowing files stored in this format to be restored to their original state. And so, in 1992, `"Anty *AJEK Copy"` was born.

![AntyAjek screenshot](scr/anty_ajek.gif)

This program might have remained lost forever, rotting in my personal junkyard, if I hadn't recently come across a tape recorded in this format. While trying to read it—nearly 30 years later—it turned out the tape used the Speedy 2700 format.

I suddenly remembered I had once written software capable of reading and restoring such files. I tried using it again, but unfortunately, not all files from the tape could be copied correctly using my old code.

The version I had written as a teenager contained serious bugs that prevented proper file recovery. Back in 1992, I simply didn’t have enough test cases to debug it thoroughly.

Now, decades later, I could finally see what mistakes I had made. Miraculously, the source code for "Anty *AJEK Copy" had survived on some of my old floppy disks.

When I looked at the code again, I genuinely wondered if I had written it—it was so primitive and unreadable, it could serve as a case study for “how not to write code.” ;)

In 1992, I used the [MAC/65](https://en.wikipedia.org/wiki/MAC/65) macro assembler. My messy code mixed decimal and hexadecimal values, used one- or two-letter labels, and referred directly to memory addresses instead of using system variable names. Looking at it now, it’s a real nightmare. I had a hard time understanding what the code even did. Still, I decided to fix the bugs and restore the files into the original Atari DOS format.

At this point, I had to decide whether to keep working with MAC/65 or switch to a cross-assembler. I initially tried [OMC/65](https://github.com/pkali/omc65), which is MAC/65-compatible, but it couldn’t handle my messy sources. So I ported the code to XASM syntax.

I cleaned up what I could, shortened the code a bit, but it’s still far from what you'd call readable. Hardware register references and system addresses (like IOCB) are still hardcoded, so yes, it's still an example of bad coding style. ;]

After nearly 30 years, I've decided to publish the source code. It contains routines for reading data in Speedy 2700 format, and maybe someday, someone else will want to recover files saved in that format. If bugs remain, now at least they can be fixed.

## How to use it

This software must be run from DOS on original Atari hardware. It reads data from cassette and writes the file segments to disk in Atari binary DOS format. A functioning `"D:"` device (disk drive) is required, hence the need for DOS.

If you're using an emulator (with turbo tape support enabled), you can use the program without DOS. However, you must enable a virtual hard disk and configure the `"H:"` device ~~to act as the `"D:"` device~~ — starting from version **1.4**, the program allows selecting `"H:"` directly.

The data buffer depends on the MEMLO value. The program uses the following memory regions:

```text
* from MEMLO to $B6FF
* from $C000 to $CFFF
* from $D800 to $FFFF
```

Your cassette recorder must have a "Turbo System" upgrade installed. This software supports Turbo 2000F/2001, AST, or Turbo K.S.O. 2000-compatible interfaces.

It reads Speedy 2700 blocks directly, so you must skip the name header and loader block, and position the tape at the *first data block* in Speedy 2700 format.

During tape reading, two types of errors may occur:

```text
Error #$8F means CRC error.
Error #$8C means pulse length error was detected
```

Both error indicates that the data on tape is probably corrupted and probably can't be recovered. You can try read the tape several times, clean tape head, or if You know what are You doing try to adjust the tape head.

## How to compile

You can use XASM or silimar syntax compatible cross-assember, for egzample [MADS](https://mads.atari8.info/).

If You are using XASM, just type:

```xasm antyajek.xsm -o antyajek.xex```

## Speedy 2700 data format

Speedy 2700 uses pulse lengths compatible with Turbo 2000F/2001/K.S.O. formats:

  - `1.00 ms pulse` — sync/pilot tone
  - `0.50 ms pulse` — represents logic "1"
  - `0.25 ms pulse` — represents logic "0"

**Block structure**

1. **Filename Block**

    - `$1000 (4096)` sync pulses
    - `$00, $FF` — block ID
    - `10 bytes` — filename
    - `1 byte` — CRC

2. **Loader Block** *(plain 3072-byte Turbo 2000 block)*

    - `$1000 (4096)` sync pulses
    - `2 bytes` — block length (Lo, Hi)
    - `3072 bytes` — data
    - `1 byte` — CRC

3. **Data Blocks** *(Speedy 2700 format)*

    - `$0600 (1536)` sync pulses
    - `2 bytes` — load address (Lo, Hi)
    - `2 bytes` — end address (Lo, Hi)
    - `block data` — stream of bytes (`block length = end_address-load_address+1`)
    - `1 byte` — CRC

### Data Block Ending Conditions

Data blocks end with one of the following:

- **INIT Segment** — Block address `$02E2–$02E3`, followed by 2 bytes `(Lo, Hi)` representing the **INIT address**  
- **EOF Marker** — `$FF, $FF` indicating **End of File**

If a file contains multiple data segments, the stream is continuous. When an INIT segment is present, a new **sync tone** appears before the next block.

## License

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org/>
