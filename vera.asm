; License: Public Domain

!ifdef VERA !eof
VERA = 1

!addr verareg =$9f20

!addr veralo  			= verareg+$0
!addr veramid 			= verareg+$1
!addr verahi  			= verareg+$2
!addr veradat 			= verareg+$3
!addr veradat2			= verareg+$4
!addr veractl 			= verareg+$5
!addr veraien 			= verareg+$6
!addr veraisr 			= verareg+$7
!addr verairqlo 		= verareg+$8

; DCSEl = 0
!addr veradcvideo		= verareg+$9
!addr veradchscale		= verareg+$a
!addr veradcvscale		= verareg+$b
!addr veradcborder		= verareg+$c

; DCSEl = 1
!addr veradchstart		= verareg+$9
!addr veradchstop		= verareg+$a
!addr veradcvstart		= verareg+$b
!addr veradcvstop		= verareg+$c

; L0
!addr veral0config		= verareg+$d
!addr veral0mapbase		= verareg+$e
!addr veral0tilebase	= verareg+$f
!addr veral0hscrolllo	= verareg+$10
!addr veral0hscrollhi	= verareg+$11
!addr veral0vscrolllo	= verareg+$12
!addr veral0vscrollhi	= verareg+$13

; L1
!addr veral1config		= verareg+$14
!addr veral1mapbase		= verareg+$15
!addr veral1tilebase	= verareg+$16
!addr veral1hscrolllo	= verareg+$17
!addr veral1hscrollhi	= verareg+$18
!addr veral1vscrolllo	= verareg+$19
!addr veral1vscrollhi	= verareg+$1a

; audio
!addr veraaudioctl		= verareg+$1b
!addr veraaudiorate		= verareg+$1c
!addr veraaudiodata		= verareg+$1d
!addr veraspidata		= verareg+$1e
!addr veraspictl		= verareg+$1f

!addr vram_sprd  = $1fc00

AUTO_INC_0 		= $000000
AUTO_INC_1 		= $100000
AUTO_INC_2 		= $200000
AUTO_INC_4 		= $300000
AUTO_INC_8 		= $400000
AUTO_INC_16		= $500000
AUTO_INC_32		= $600000
AUTO_INC_64		= $700000
AUTO_INC_128	= $800000
AUTO_INC_256	= $900000
AUTO_INC_512	= $A00000
AUTO_INC_40		= $B00000
AUTO_INC_80		= $C00000
AUTO_INC_160	= $C00000
AUTO_INC_320	= $E00000
AUTO_INC_640	= $F00000

SPRITE_SIZE_8	= $0
SPRITE_SIZE_16	= $1
SPRITE_SIZE_32	= $2
SPRITE_SIZE_64	= $3

!macro vset .addr {
	lda #0
	sta veractl
	lda #<(.addr >> 16) | $10
	sta verahi
	lda #<(.addr >> 8)
	sta veramid
	lda #<(.addr)
	sta veralo
}

!macro vset2 .addr {
	lda #1
	sta veractl
	lda #<(.addr >> 16) | $10
	sta verahi
	lda #<(.addr >> 8)
	sta veramid
	lda #<(.addr)
	sta veralo
}

!macro vstore .addr {
	pha
	+vset .addr
	pla
	sta veradat
}

!macro vstore2 .addr {
	pha
	+vset .addr
	pla
	sta veradat2
}

!macro vload .addr {
	+vset .addr
	lda veradat
}

!macro vload2 .addr {
	+vset .addr
	lda veradat2
}

!macro sprset .offset {
	lda #<(vram_sprd >> 16) | $10
	sta verahi
	txa
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc #<(vram_sprd + .offset >> 8)
	sta veramid
	txa
	asl
	asl
	asl
	clc
	adc #<((vram_sprd + .offset))
	sta veralo
}

!macro sprload .offset {
	+sprset .offset
	lda veradat
}

!macro sprload2 .offset {
	+sprset .offset
	lda veradat2
}

!macro sprstore .offset {
	pha
	+sprset .offset
	pla
	sta veradat
}

!macro sprstore2 .offset {
	pha
	+sprset .offset
	pla
	sta veradat2
}

!macro video_init {
	lda #0
	sta veractl ; set ADDR1 active
	sta veramid
	lda #$1F    ; $F0000 increment 1
	sta verahi
	lda #$00
	sta veralo
	lda #1
	sta veradat ; VGA output
}
