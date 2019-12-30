!src "vera.inc"

*=$1000

getjoy = $ff56
joy1_main = $00ef
joy1_scnd = $ff53

init:
	lda #0
	sta veractl
	lda #$20
	sta veralo
	lda #0
	sta veramid
	lda #$20
	sta verahi

prg:
	ldx #0
-	lda .string,x
	beq +
	sta veradat
	inx
	jmp -

+	jsr joy1_scnd
	ldx #0

loop:
	jsr getjoy
	and #128
	bne loop
	rts

.string !scr "hello, world!",0 
