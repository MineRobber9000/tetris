; The main source file

INCLUDE "macros.asm"

SECTION "RST Handlers",ROM0[$0000]
rst00:
	jp $020c
	fillnull 5
rst08:
	jp $020c
	fillff 29
rst28:
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
SECTION "Interrupt Handlers",ROM0[$0040]
VBlankIRQ:
	jp $017e
	fillff 5
LCDStatIRQ:
	jp $26be
	fillff 5
TimerIRQ:
	jp $26be
	fillff 5
SerialIRQ:
	jp Unknown005b
Unknown005b:
        push af
        push hl
        push de
        push bc
        call $006b
        ld a, $01
        ld [$ffcc], a
        pop bc
        pop de
        pop hl
        pop af
        reti
Unknown006b:
	ldh a, [$cd]
	rst $28
.unknownPtrTable:
	dw $0078
	dw $009f
	dw $00a4
	dw $00ba
	dw $27ea
	ldh a,[$e1]
	cp $07
	jr z, .jrone
	cp $06
	ret z
	ld a, $06
	ldh [$e1], a
	ret
.jrone	ldh a, [$01]
	cp $55
	jr nz, .jrtwo
	ld a, $29
	ldh [$cb], a
	ld a, $01
	jr .jrthr
.jrtwo	cp $29
	ret nz
	ld a, $55
	ldh [$cb], a
	xor a
.jrthr	ldh [$02], a
	ret
