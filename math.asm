;==================================================
; decimal_chars_8
; Takes an 8-bit value and turns it into a string
; of characters in decimal.  The A register passes
; in the value to be converted, and the resulting
; zero terminated string is pointed to be u0.
; void decimal_chars_8(byte value: a,
;						out num_digits: y)
;
; NOTE IMPORTANT: the stack will be populated with
; y digits that must be popped in order for the
; next rts to function properly.
;==================================================
decimal_chars_8:
	; zero y
	ldy #0
	; use u1 as the scratchpad
	sta u1L

	; pull the return address off the stack and save for later
	pla
	sta u0L
	pla
	sta u0H

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
	; so we push it to the stack
	lda u1H
	pha
	iny

	; check if we are done
	lda u1L
	bne decimal_chars_8_initialize_remainder

	; at this point, the stack contains the digits, with the highest order at the top

	; push the return address back to the stack
	lda u0H
	pha
	lda u0L
	pha
	
	rts
