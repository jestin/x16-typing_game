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
