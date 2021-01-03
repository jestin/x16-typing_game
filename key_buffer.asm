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
	beq GET_KEYBOARD_INPUT_END
	cmp #$3		; ESC
	bne +

	; clear buffer on ESC
	lda #0
	sta zp_key_buffer_length
	jmp GET_KEYBOARD_INPUT_END

	; Translate to ASCII
+	cmp #$80				; anything less than 128 means it was hit without SHIFT
	bmi +
	; lowercase was typed
	sec
	sbc #$80				; converts to lowercase ascii
	jmp GET_KEYBOARD_INPUT_ADD_BUFFER
+	clc
	adc #$20				; converts to uppercase ascii

GET_KEYBOARD_INPUT_ADD_BUFFER:
	; add the pressed key to the buffer
	ldx zp_key_buffer_length
	sta zp_key_buffer,x
	inx
	txa
	sta zp_key_buffer_length

GET_KEYBOARD_INPUT_END:
	rts
