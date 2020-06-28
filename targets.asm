;==================================================
; Targets represent the text that a player needs to
; type in order to play the game.  The targets will
; be dropping from the top of the screen, and the
; player will need to type the text of the target
; in order to get rid of that target.
;
; The targets are stored in memory as follows:
; ------------------------------------------------
; |00| Low byte of X coordinate                  |
; |01| High byte of X coordinate                 |
; |02| Low byte of Y coordinate                  |
; |03| High byte of Y coordinate                 |
; |04| Low byte of ticks-per-pixel speed         |
; |05| High byte of ticks-per-pixel speed        |
; |06| Low byte of string address                |
; |07| High byte of string address               |
; ------------------------------------------------
;==================================================

;==================================================
; set_target
; Defines a target
; void set_target(byte target_index: x,
;					word string_addr: u0,
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
	sta target_data,y
	iny
	lda u1H
	sta target_data,y
	iny

	; store the y position
	lda u2L
	sta target_data,y
	iny
	lda u2H
	sta target_data,y
	iny

	; store the ticks per pixel
	lda u3L
	sta target_data,y
	iny
	lda u3H
	sta target_data,y
	iny

	; store the string address
	lda u0L
	sta target_data,y
	iny
	lda u0H
	sta target_data,y

	rts
