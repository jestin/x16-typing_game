;==================================================
; set_target
; Defines a target
; void set_target(byte target_index: x,
;					word string_index: u0,
;					word x_position: u1,
;					word y_position: u2,
;					byte ticks_per_pixel: u3L)
;==================================================
set_target:
	; Multiply x by 8 and store in y since
	; that's how many bytes a target is.
	; This allows us to use ($zp),y 
	; addressing.
	txa
	asl
	asl
	asl
	tay

	; store the x position
	lda u1L
	sta (zp_targets),y
	iny
	lda u1H
	sta (zp_targets),y
	iny

	; store the y position
	lda u2L
	sta (zp_targets),y
	iny
	lda u2H
	sta (zp_targets),y
	iny

	; store the ticks per pixel
	lda u3L
	sta (zp_targets),y
	iny
	lda u3H
	sta (zp_targets),y
	iny

	; store the string index
	lda u0L
	sta (zp_targets),y
	iny
	lda u0H
	sta (zp_targets),y

	rts
