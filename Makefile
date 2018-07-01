ASMFILES:= $(wildcard src/*.asm)
OBJFILES:= $(ASMFILES:.asm=.o)

tetris.gb: $(OBJFILES)
	rgblink -O baserom.gb -o tetris.gb -n tetris.sym -d $(OBJFILES)
	rgbfix -t "TETRIS" -r 0x00 -n 0x01 -l 0x01 tetris.gb
	tools/symsort

%.o: %.asm
	rgbasm -o $@ -iinc/ $^

.PHONY: verify clean symwatch
verify:
	@md5sum -c tetris.md5
clean:
	rm tetris.gb tetris.sym $(OBJFILES)
symwatch:
	tools/symwatch
