fill: MACRO
REPT \2
	db \1
ENDR
ENDM
fillnull: MACRO
	fill $00,\1
ENDM
fillff: MACRO
	fill $ff,\1
ENDM
