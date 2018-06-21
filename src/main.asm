; The main source file

INCLUDE "macros.asm"
INCLUDE "hardware.inc"

SECTION "Interrupt Handlers",ROM0[$0040]
VBlankIRQ::
	jp VBlank
	fillff 5
LCDStatIRQ::
	jp DummyInterruptHandler
	fillff 5
TimerIRQ::
	jp DummyInterruptHandler
	fillff 5
SerialIRQ::
	jp Unknown005b
Unknown005b::
	push af
	push hl
	push de
	push bc
	call Unknown006b
	ld a, $01
	ld [$ffcc], a
	pop bc
	pop de
	pop hl
	pop af
	reti
Unknown006b::
	ldh a, [$cd]
	rst $28
.unknownPtrTable::
	dw Unknown0078
	dw Unknown009f
	dw Unknown00a4
	dw Unknown00ba
	dw $27ea
Unknown0078::
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
Unknown009f::
	ldh a,[$01]
	ldh [$d0],a
	ret
Unknown00a4::
	ldh a, [$01]
	ldh [$d0], a
	ldh a, [$cb]
	cp $29
	ret z
	ldh a, [$cf]
	ldh [$01], a
	ld a, $ff
	ldh [$cf], a
	ld a, $80
	ldh [$02], a
	ret
Unknown00ba::
	ldh a, [$01]
	ldh [$d0], a
	ldh a, [$cb]
	cp $29
	ret z
	ldh a, [$cf]
	ldh [$01], a
	ei
	call $0a98
	ld a, $80
	ldh [$02], a
	ret
Unused00d0::
	ldh a, [$cd]
	cp $02
	ret nz
	xor a
	ldh [$0f], a
	ei
	ret
	fillff ($100-$da)
entrypoint::
	nop
	jp entrypoint2
SECTION "Unknown014b",ROM0[$014B]
Unknown014b::
	ld bc, $0a01
	ld d, $bf
SECTION "Main",ROM0[$0150]
entrypoint2::
	jp Unknown020c
Unused0153::
	call $29e3
.loop	ldh a, [rSTAT]
	and $03
	jr nz, .loop
	ld b, [hl]
.loop2	ldh a, [rSTAT]
	and $03
	jr nz, .loop2
	ld a, [hl]
	and b
	ret
Unknown0166::
        ld a, e
        add [hl]
        daa
        ldi [hl], a
        ld a, d
        adc [hl]
        daa
        ldi [hl], a
        ld a, $00
        adc [hl]
        daa
        ld [hl], a
        ld a, $01
        ldh [$e0], a
        ret nc
        ld a, $99
        ldd [hl], a
        ldd [hl], a
        ld [hl], a
        ret
VBlank::
	push af
	push bc
	push de
	push hl
	ldh a, [$ce]
	and a
	jr z, .jrone
	ldh a, [$cb]
	cp $29
	jr nz, .jrone
	xor a
	ldh [$ce], a
	ldh a, [$cf]
	ldh [$01], a
	ld hl, $ff02
	ld [hl], $81
.jrone	call $21e0
	call $23cc
	call $23b7
	call $239e
	call $238c
	call $237d
	call $236e
	call $235f
	call $2350
	call $2341
	call $2332
	call $2323
	call $22f8
	call $22e9
	call $22da
	call $22cb
	call $22bc
	call $22ad
	call $229e
	call $1ed7
	call $ffb6
	call $18ca
	ld a, [$c0ce]
	and a
	jr z, .jrtwo
	ldh a, [$98]
	cp $03
	jr nz, .jrtwo
	ld hl, $986d
	call $243b
	ld a, $01
	ldh [$e0], a
	ld hl, $9c6d
	call $243b
	xor a
	ld [$c0ce], a
.jrtwo	ld hl, $ffe2
	inc [hl]
	xor a
	ldh [$43], a
	ldh [$42], a
	inc a
	ldh [$85], a
	pop hl
	pop de
	pop bc
	pop af
	reti
Unknown020c::
	xor a
	; clear loop (clears $cfff-$dfff):
	; Uses cb (not bc) for whatever reason as a loop counter.
	ld hl,wUnknownDFFF
	ld c,$10
	ld b,$00
.cloop	ld [hld],a
	dec b
	jr nz,.cloop
	dec c
	jr nz,.cloop
	ld a,$01
	di
	ld [rIF],a
	ld [rIE],a
	xor a
	ld [rSCY],a
	ld [rSCX],a
	ld [$ffa4],a
	ld [rSTAT],a
	ld [rSB],a
	ld [rSC],a
	ld a, LCDCF_ON ; turn on LCD
	ld [rLCDC],a
.wloop	ld a,[rLY]
	cp $94
	jr nz,.wloop
	ld a, LCDCF_OBJON | LCDCF_BGON
	ld [rLCDC],a
	ld a, %11100100
	ld [rBGP],a
	ld [rOBP0],a
	ld a, %11000100
	ld [rOBP1],a
	ld hl, rNR52
	ld a, $80
	ld [hld],a
	ld a, $ff
	ld [hld],a
	ld [hl],$77
	ld a,$01
	ld [rROMB0],a
	ld sp,$cfff
SECTION "DummyInterruptHandler Temp Section",ROM0[$26be]
DummyInterruptHandler::
	reti
