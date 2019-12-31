!src "vera.inc"

*=$1000

zp_color_addr =$00

!macro write_string .addr {
	; push x and a to the stack
	pha
	txa
	pha

	ldx #0
-	lda .addr,x
	beq +
	+write_char
	inx
	jmp -

	; restore x and a
+	pla
	tax
	pla
}

!macro write_char {
	sta veradat
	lda zp_color_addr 		;foreground/background color
	sta veradat
}

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
	lda #$59
	sta zp_color_addr
	+write_string .str_another_string
	jmp end

init:
	lda #0
	sta veractl
	sta veralo
	sta veramid
	lda #$10		;set increment to 1, high address to 0
	sta verahi
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
	rts

.str_hello_world !scr "hello, world!",0 
.str_another_string !scr "this is another string",0 
