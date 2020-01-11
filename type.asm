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

	ldx #33
-	txa
	clc
	pha
	jsr CONSOLE_put_char
	pla
	tax
	inx
	cpx #147
	bne -


	jmp end


end:
	jmp *
	rts

!src "strings.inc"
