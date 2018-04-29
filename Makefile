ASMFILES:= $(wildcard src/*.asm)
OBJFILES:= $(ASMFILES:.asm=.o)

tetris.gb: $(OBJFILES)
	rgblink -O baserom.gb -o tetris.gb $(OBJFILES)

%.o: %.asm
	rgbasm -o $@ $^

.PHONY: verify clean
verify:
	@md5sum -c tetris.md5
clean:
	rm tetris.gb $(OBJFILES)
