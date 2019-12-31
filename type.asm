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
	sta veradat
	lda zp_color_addr
	sta veradat
	inx
	jmp -

	; restore x and a
+	pla
	tax
	pla
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
; write_char
;
; This expects a color and a character pushed to the stack, and will write that
; character with that color to the current position of veradat
;------------------------------------------------------------------------------
write_char:
	; push the return address to the zero page
	pla			;low byte of return
	sta $0
	pla			;high byte of return
	sta $1

	pla			;character
	sta veradat
	pla 		;foreground/background color
	sta veradat

	; pop the return address from the zero page
	lda $1
	pha
	lda $0
	pha
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

	ldx #0
	ldy #0
-	jsr set_vera_xy
	lda #$00 		;color
	pha
	lda #$20		;character
	pha
	jsr write_char
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
