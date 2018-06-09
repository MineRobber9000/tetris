; The reset vectors

INCLUDE "macros.asm"

SECTION "RST Vectors",ROM0[$0000]
rst00::
	jp Unkown020c
	fillnull 5
rst08::
	jp Unkown020c
	fillff 5
rst10::
	fillff 8
rst18::
	fillff 8
rst20::
	fillff 8
Jumptable:: ; rst $28
	add a
	pop hl
	ld e,a
	ld d,$00
	add hl,de
	ld e,[hl]
	inc hl
	ld d,[hl]
	push de
	pop hl
	jp hl
	fillff 12
