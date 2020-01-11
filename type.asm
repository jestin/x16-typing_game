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
	+LoadW r1, 0
	+LoadW r2, 0
	+LoadW r3, 0
	jsr CONSOLE_init

	ldx #161
-	txa
	clc
	pha
	jsr CONSOLE_put_char
	pla
	tax
	cpx #255
	beq +
	inx
	jmp -

+	jmp end


end:
	jmp *
	rts

!src "strings.inc"
