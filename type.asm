!src "vera.asm"
!src "zp.asm"
!src "macros.asm"
!src "x16.asm"

*=$1000

main:
	lda #$80
	sec
	jsr screen_set_mode

	+LoadW r0, 0
	jsr GRAPH_init

	lda #1
	ldx #0
	ldy #0
	jsr GRAPH_set_colors
	jsr GRAPH_clear

	jsr draw_border
	jmp end

	; draw full pallet
	+LoadW r0, 0
	+LoadW r1, 0
	+LoadW r2, 0
	+LoadW r3, 198

-	lda r0L
	clc
	adc #110
	jsr GRAPH_set_colors
	jsr GRAPH_draw_line
	inc r0L
	inc r2L
	bne -

	jmp end

draw_border:
	; left
	+LoadW r0, 0
	+LoadW r1, 0
	+LoadW r2, 0
	+LoadW r3, 200
	
-	lda r0L
	clc
	adc #110
	jsr GRAPH_set_colors
	jsr GRAPH_draw_line
	inc r0L
	inc r2L
	lda r0L
	cmp #7
	bne -

	; right
	+LoadW r0, 312
	+LoadW r1, 0
	+LoadW r2, 312
	+LoadW r3, 200
	
-	lda r0L
	clc
	adc #110
	jsr GRAPH_set_colors
	jsr GRAPH_draw_line
	inc r0L
	inc r2L
	lda r0L
	cmp #7
	bne -

	rts

end:
	jmp *
	rts

!src "strings.inc"
