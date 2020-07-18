NUM_TARGETS = 8
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
;					word ticks_per_pixel: u3)
;==================================================
set_target:
	; Multiply x by 8 and store in y since
	; that's how many bytes a target is.
	; This allows us to use absolute,y
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

;==================================================
; update_target_pos
; Update the target's x and y coordinates
; void update_target_pos(byte target_index: x)
;==================================================
update_target_pos:
	tya
	pha

	; set y to the correct offset for the target
	txa
	asl
	asl
	asl
	tay

	; skip past the x coordinate
	iny
	iny

	; TODO: read the ticks per pixel values,
	; and increment based on that.
	; I may want to re-order the target data,
	; since now I have to skip ahead and then
	; skip back in order to adjust y.

	; increment the lower byte
	lda target_data,y
	inc
	sta target_data,y
	bne +				; when negative is set, it means rollover

	; increment the high byte
	iny
	lda target_data,y
	inc
	sta target_data,y

+	pla
	tay
	rts

;==================================================
; set_target_pos
; Update the sprite positions of the target's string.
; void set_target_pos(byte target_index: x)
;==================================================
set_target_pos:
	; First, we need to set zp_cur_target_addr
	; We do this by successively adding two bytes to
	; to target_data, one time for each index past 0.
	; We push X first, so that we don't lose it.
	+LoadW zp_cur_target_addr, target_data
	phx
-	cpx #0
	beq +
	+AddW zp_cur_target_addr, 8
	dex
	jmp -
+	nop			; meh, I'll waste a couple cycles for readability

	; At this point, zp_cur_target_addr is set to the correct address,
	; so we should set zp_cur_target_string_addr.

	ldy #6
	lda (zp_cur_target_addr),y
	sta zp_cur_target_string_addr
	iny
	lda (zp_cur_target_addr),y
	sta zp_cur_target_string_addr+1

	; Now we read the x and y position from the data, and set the sprites

	; Move the x coordinate to u0
	ldy #0
	lda (zp_cur_target_addr),y
	sta u0L
	iny
	lda (zp_cur_target_addr),y
	sta u0H
	; Move the y coordinate to u1
	iny
	lda (zp_cur_target_addr),y
	sta u1L
	iny
	lda (zp_cur_target_addr),y
	sta u1H

	ldy #1			; the sprite indices start at byte 1
-	lda (zp_cur_target_string_addr),y
	cmp #255		; compare to sentinel value
	beq +
	tax
	jsr set_sprite_pos
	iny
	+AddW u0, 8
	jmp -

+	plx				; restore X
	rts

;==================================================
; clear_target
; Clears a target, by setting the string address
; to a sentinel value.
; void clear_target(byte target_index: x)
;==================================================
clear_target:
	; Multiply x by 8 and store in y since
	; that's how many bytes a target is.
	; This allows us to use ($zp),y 
	; addressing.
	txa
	asl
	asl
	asl
	tay

	; set the X value to $FFFF, which we will interpret as null
	lda #255
	sta target_data,y
	iny
	sta target_data,y

	rts

