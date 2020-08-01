;==================================================
; get_keyboard_input
; Gets the keyboard input and stores it in the
; key buffer.
; void get_keyboard_input()
;==================================================
get_keyboard_input:
	; get keyboard input
	jsr GETIN
	cmp #0
	beq +

	; add the pressed key to the buffer
	ldx zp_key_buffer_length
	sta zp_key_buffer,x
	inx
	txa
	sta zp_key_buffer_length

+	rts
