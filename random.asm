;==================================================
; get_random_byte
; Gathers entropy from the machine and combines
; it into a single pseudo-random byte.
; byte: u0L get_random_byte()
;==================================================
get_random_byte:
	jsr entropy_get
	stx u15H
	eor u15H
	sty u15H
	eor u15H

	rts

;==================================================
; get_random_nibble
; Gathers entropy from the machine and combines
; it into a single pseudo-random nibble ($0X).
; byte: u0L get_random_byte()
;==================================================
get_random_nibble:
	jsr get_random_byte
	lsr
	lsr
	lsr
	lsr

	rts

;==================================================
; get_random_bit
; Gathers entropy from the machine and combines
; it into a single pseudo-random bit ($00 or $01).
; byte: u0L get_random_byte()
;==================================================
get_random_bit:
	jsr get_random_byte
	lsr
	lsr
	lsr
	lsr

	rts
