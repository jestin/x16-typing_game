!src "vera.inc"

*=$1000

main:
	jsr init
	ldx #5
	ldy #20
	jsr set_vera_xy
	jsr write_hello
	jsr test
	jmp end

write_hello:
	lda #$20		;set increment to 2, high address to 0
	sta verahi
	ldx #0
-	lda .string,x
	beq +
	sta veradat
	inx
	jmp -
+	rts

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

	lda #$10		;set increment to 1, high address to 0
	sta verahi

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

test:
	ldx #79
	ldy #59
-	jsr set_vera_xy
	lda #$01 		;color
	pha
	lda #$00		;character
	pha
	jsr write_char
	inx
	rts

end:
	rts

.string !scr "hello, world!",0 
