!ifndef TYPE
TYPE = 1

!src "vera.asm"
!src "zp.asm"
!src "macros.asm"

*=$1000

main:
	jsr init
	jsr clear_screen
	ldx #5
	ldy #20
-	jsr set_vera_xy
	lda #$01
	sta zp_color_addr
	+write_string .str_hello_world
	cpy #25
	beq +
	iny
	jmp -
+	ldx #0
	ldy #0
	jsr set_vera_xy

	lda #$01
	sta zp_color_addr
	lda #0
	sta zp_skip_addr
	lda #$03
	sta zp_take_addr
	+write_string .str_another_string
	lda #$10
	sta zp_color_addr
	lda #$03
	sta zp_skip_addr
	lda #$ff
	sta zp_take_addr
	+write_string .str_another_string

	jmp end

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
