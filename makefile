xex:
	xasm antyajek.xsm -o antyajek.xex

chk:	xex
	chkxex antyajek.xex

run:	xex
	atari800 antyajek.xex

boot:	atr
	atari800 antyajek.atr

atr:	xex
	cp antyajek.xex antyajek.com
	mkatr -s 368640 antyajek.atr dos/ -b dos/XBW130.DOS dos/BOOT.COM dos/BLOAD.COM dos/COPY.COM dos/DUMP.COM dos/MEM.COM dos/OFFLOAD.COM antyajek.com
	rm -f antyajek.com

zip:	clean xex atr
	7z -mx9 a releases/antyajek_v.1.x.zip antyajek.xex antyajek.atr

clean:
	rm -f *.xex
	rm -f *.atr

