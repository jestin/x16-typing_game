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


init:
	; init vera
	lda #0
	sta veractl
	sta veralo
	sta veramid
	lda #$10		;set increment to 1, high address to 0
	sta verahi

	; init zero page
	lda #0
	sta zp_color_addr
	sta zp_skip_addr
	lda #$ff
	sta zp_take_addr
	rts

;------------------------------------------------------------------------------
; set_vera_xy
;
; This expects the X and Y registers to be set to the desired XY postition, and
; then sets veralo, veramid, and verahi accordinglingly
;------------------------------------------------------------------------------
set_vera_xy:
	pha			;push accumulator to the stack

	tya			;transfer y to the accumulator
	sta veramid
	txa			;pop x from stack
	asl
	sta veralo	;store in vera low byte address

	pla			;pop accumulator from the stack
	rts

clear_screen:
	pha			;push accumulator to the stack

	lda #$00 		;color
	sta zp_color_addr
	ldx #0
	ldy #0
-	jsr set_vera_xy
	lda #$20		;character
	+write_char
	cpx #79
	bne +			; on 79, increment Y and reset X
	cpy #59
	beq ret
	iny
	ldx #0
	jmp -
+	inx
	jmp -
ret:
	pla			;pop accumulator from the stack
	rts

end:
	jmp *
	rts

!src "strings.inc"
