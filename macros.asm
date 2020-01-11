!ifdef MACROS !eof
MACROS = 1

!macro LoadB .dest, .value {
	lda #.value
	sta .dest
}

!macro LoadW .dest, .value {
	lda #<(.value)
	sta .dest
	lda #>(.value)
	sta .dest+1
}

!macro MoveB .source, .dest {
	lda .source
	sta .dest
}

!macro MoveW .source, .dest {
	MoveB .source+.0, .dest+0
	MoveB .source+1, .dest+1
}

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
