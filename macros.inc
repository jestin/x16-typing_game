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

!macro write_partial_string .addr, .skip, .take {
	; push x, y, and a to the stack
	pha
	txa
	pha
	tya
	pha

	ldx #.skip
	ldy #.take
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
