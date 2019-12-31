!src "vera.inc"

*=$1000

main:
	jsr init
	; jsr dump
	jsr test
	jmp end;

	ldx #0
-	lda .string,x
	beq +
	sta veradat
	inx
	jmp -

+	jmp end

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

test:
	ldx #0
-	txa 		;color
	pha
	lda #$00	;character
	pha
	jsr write_char
	cpx #$ff
	beq +
	inx
	jmp -
+	rts

end:
	rts

.string !scr "hello, world!",0 
