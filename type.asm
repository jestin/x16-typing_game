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

	; lda #1
	; ldx #0
	; ldy #0
	; jsr GRAPH_set_colors
	jsr GRAPH_clear

	jsr draw_border

	jmp end

draw_border:
	lda #0
	jsr GRAPH_set_colors

	; outer rect
	; To make the outer rectangle 2 pixels wide, we draw two rectanlges
	+LoadW r0, 0
	+LoadW r1, 0
	+LoadW r2, 320
	+LoadW r3, 200
	+LoadW r4, 0
	jsr GRAPH_draw_rect
	+LoadW r0, 1
	+LoadW r1, 1
	+LoadW r2, 318
	+LoadW r3, 198
	clc						; no reason to fill this rect
	jsr GRAPH_draw_rect

	; middle rect (fill)
	+LoadB r4L, 0 			; loop counter
	+LoadB r4H, 108			; color

-	lda r4H
	jsr GRAPH_set_colors
	inc r0L
	inc r1L
	dec r2L
	dec r2L
	dec r3L
	dec r3L
	; +LoadW r0, 2
	; +LoadW r1, 2
	; +LoadW r2, 317
	; +LoadW r3, 197
	clc						; no reason to fill this rect
	jsr GRAPH_draw_rect
	inc r4L
	dec r4H
	lda r4L
	cmp #7
	beq +
	jmp -

+	rts

end:
	jmp *
	rts

!src "strings.inc"
