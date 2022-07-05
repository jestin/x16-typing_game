.segment "CODE"

;==================================================
; decimal_chars_8
; Takes an 8-bit value and turns it into an array
; of lsb-first decimal values.  The A register passes
; in the value to be converted and the Y register
; returns how long the array is.
;
; void decimal_chars_8(byte value: a,
;						word address: u0,
;						out num_digits: y)
;
;==================================================
decimal_chars_8:
	; zero y
	ldy #0
	; use u1 as the scratchpad
	sta u1L

decimal_chars_8_initialize_remainder:
	lda #0
	sta u1H
	clc

	ldx #8
decimal_chars_8_div_loop:
	rol u1L
	rol u1H
	sec
	lda u1H
	sbc #10
	bcc decimal_chars_8_ignore_result
	sta u1H
decimal_chars_8_ignore_result:
	dex
	bne decimal_chars_8_div_loop
	rol u1L							; rotating only the low byte to get the quotient

	; at this point, u1H contains the remainder, and u1L contains the quotient
	; so we store it in the array pointed to by u0
	lda u1H
	sta (u0),y
	iny

	; check if we are done
	lda u1L
	bne decimal_chars_8_initialize_remainder

	; at this point, the stack contains the digits, with the highest order at the top
	
	rts

;==================================================
; decimal_chars_16
; Takes an 16-bit value and turns it into an array
; of lsb-first decimal values.  The A register passes
; in the value to be converted and the Y register
; returns how long the array is.

; void decimal_chars_16(word value: u1,
;						word address: u0,
;						out num_digits: y)
;
;==================================================
decimal_chars_16:
	; zero y
	ldy #0
	; use u1 and u2 as the scratchpad
	LoadW u2, 0

decimal_chars_16_initialize_remainder:
	LoadW u2, 0
	clc

	ldx #16
decimal_chars_16_div_loop:
	rol u1L
	rol u1H
	rol u2L
	rol u2H
	sec
	lda u2L
	sbc #10
	bcc decimal_chars_16_ignore_result
	sta u2L
decimal_chars_16_ignore_result:
	dex
	bne decimal_chars_16_div_loop
	rol u1L							; rotating only the low word to get the quotient
	rol u1H

	; at this point, u2L contains the remainder, and u1 contains the quotient
	; so we store it in the array pointed to by u0
	lda u2L
	sta (u0),y
	iny

	; check if we are done
	lda u1L
	ora u1H
	bne decimal_chars_16_initialize_remainder

	; at this point, the stack contains the digits, with the highest order at the top
	
	rts
