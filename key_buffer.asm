.segment "CODE"

;==================================================
; get_keyboard_input
; Gets the keyboard input and stores it in the
; key buffer.
; void get_keyboard_input()
;==================================================
get_keyboard_input:
	; get keyboard input
	jsr GETIN			; sets Z flag if nothing is there
	beq @return
	cmp #$3		; ESC
	bne :+

	; clear buffer on ESC
	lda #0
	sta zp_key_buffer_length
	jmp @return

	; Translate to ASCII
:	cmp #$80				; anything less than 128 means it was hit without SHIFT
	bmi :+
	; lowercase was typed
	sec
	sbc #$80				; converts to lowercase ascii
	jmp @get_keyboard_input_add_buffer
:	clc
	adc #$20				; converts to uppercase ascii

@get_keyboard_input_add_buffer:
	; add the pressed key to the buffer
	ldx zp_key_buffer_length
	sta zp_key_buffer,x
	inx
	txa
	sta zp_key_buffer_length

	; continue fetching until the X16's key buffer is empty
	bra get_keyboard_input

@return:
	rts
