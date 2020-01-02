!ifdef MACROS !eof

MACROS = 1

!macro write_string .addr {
	; push x, y, and a to the stack
	pha
	txa
	pha
	tya
	pha

	ldx zp_skip_addr
	ldy zp_take_addr
-	lda .addr,x
	beq +
	cpy #0
	beq +
	+write_char
	inx
	dey
	jmp -

	; restore x, y, and a
+	pla
	tay
	pla
	tax
	pla
}

!macro write_char {
	sta veradat
	lda zp_color_addr 		;foreground/background color
	sta veradat
}
