ASMFILES:= $(wildcard src/*.asm)
OBJFILES:= $(ASMFILES:.asm=.o)

tetris.gb: $(OBJFILES)
	rgblink -O baserom.gb -o tetris.gb $(OBJFILES)
	rgbfix -t "TETRIS" -r 0x00 -n 0x01 -l 0x01 tetris.gb

%.o: %.asm
	rgbasm -o $@ $^

.PHONY: verify clean
verify:
	@md5sum -c tetris.md5
clean:
	rm tetris.gb $(OBJFILES)
