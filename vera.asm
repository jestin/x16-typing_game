; License: Public Domain

!ifdef VERA !eof
VERA = 1

!if MACHINE_C64 = 1 {
	!addr verareg =$df00
} else {
	!addr verareg =$9f20
}
!addr veralo  = verareg+0
!addr veramid = verareg+1
!addr verahi  = verareg+2
!addr veradat = verareg+3
!addr veradat2= verareg+4
!addr veractl = verareg+5
!addr veraien = verareg+6
!addr veraisr = verareg+7

!addr vreg_cmp  = $F0000
!addr vreg_pal  = $F1000
!addr vreg_lay1 = $F2000
!addr vreg_lay2 = $F3000
!addr vreg_spr  = $F4000
!addr vreg_sprd = $F5000

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
AUTO_INC_1024	= $B00000
AUTO_INC_2048	= $C00000
AUTO_INC_8192	= $E00000
AUTO_INC_16384	= $F00000

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
	lda #<(vreg_sprd >> 16) | $10
	sta verahi
	txa
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc #<(vreg_sprd + .offset >> 8)
	sta veramid
	txa
	asl
	asl
	asl
	clc
	adc #<((vreg_sprd + .offset))
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
