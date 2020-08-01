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
; |04| Ticks-per-pixel speed			         |
; |05| Current ticks                             |
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
;					word ticks_per_pixel: u3L)
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

	; initialize current ticks to zero
	lda #0
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
	phy
	phx

	+SetZpCurTargetAddr

	; read ticks per pixel
	ldy #4
	lda (zp_cur_target_addr),y
	sta u0L

	; at this point, u0L has the ticks per pixel

	; load current ticks
	ldy #5
	lda (zp_cur_target_addr),y
	sta u0H			; store the current tick count

	cmp u0L
	bne + 			; if not equal, do not update position

	; first set the current tick count so that the next inc
	; will be zero
	lda #$ff
	sta u0H

	; update the position
	ldy #2

	; increment the lower byte
	lda (zp_cur_target_addr),y
	inc
	sta (zp_cur_target_addr),y
	bne +				; when zero is set, it means rollover

	; increment the high byte
	iny
	lda (zp_cur_target_addr),y
	inc
	sta (zp_cur_target_addr),y

+	lda u0H			; load the temp var for tick count,
					; regardless of whether it was reset or not
	inc
	ldy #5
	sta (zp_cur_target_addr),y

	plx
	ply
	tay

	rts

;==================================================
; update_target_chars
; Update the target's typed characters
; void update_target_chars(byte target_index: x)
;==================================================
update_target_chars:
	phy
	phx

	+SetZpCurTargetStringAddr

	; determine if the buffer matches.  If so,
	; change the pallete of the first
	; zp_key_buffer_length sprites in the string

	; the first byte of the target string
	; is the index into the string map
	lda (zp_cur_target_string_addr)

	; multiply by 2 since each address in the
	; string map is 2 bytes
	asl
	tax		; x is now the offset into the string map
	lda string_map,x
	sta zp_string_addr

	; zp_string_addr now points to the program memory that
	; holds the actual string

	; store 0 for false in u0L
	lda #(SPRITE_SIZE_8 << 6) | (SPRITE_SIZE_8 << 4) | 0		; height/width/paloffset
	sta u0L

	; loop through the buffer and compare against current char
	ldy #$ff
-	iny
	cpy zp_key_buffer_length
	beq +
	lda #(SPRITE_SIZE_8 << 6) | (SPRITE_SIZE_8 << 4) | 3		; height/width/paloffset
	sta u0L
	lda zp_key_buffer,y	
	cmp (zp_string_addr),y
	beq -

	; if we make it here, it means the string doesn't match
	lda #(SPRITE_SIZE_8 << 6) | (SPRITE_SIZE_8 << 4) | 0		; height/width/paloffset
	sta u0L


	; loop through the sprites and change the pallete offset
+	ldy #1			; the sprite indices start at byte 1
-	lda (zp_cur_target_string_addr),y
	cmp #255		; compare to sentinel value
	beq +
	tax
	lda u0L
	+sprstore 7
	cpy zp_key_buffer_length
	beq +
	iny
	jmp -

+	plx
	ply

	rts

;==================================================
; set_target_pos
; Update the sprite positions of the target's string.
; void set_target_pos(byte target_index: x)
;==================================================
set_target_pos:
	phx

	+SetZpCurTargetStringAddr

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
; clear_target_sprites
; Clears the target's sprites.
; void clear_target_sprites(byte target_index: x)
;==================================================
clear_target_sprites:
	phx

	+SetZpCurTargetStringAddr

	ldy #1			; the sprite indices start at byte 1
-	lda (zp_cur_target_string_addr),y
	cmp #255		; compare to sentinel value
	beq +
	tax
	jsr clear_sprite
	iny
	jmp -

+	nop

	plx
	rts

;==================================================
; clear_target
; Clears a target, by setting the string address
; to a sentinel value.
; void clear_target(byte target_index: x)
;==================================================
clear_target:
	phx

	+SetZpCurTargetAddr

	; set the X value to $FFFF, which we will interpret as null
	ldy #0
	lda #255
	sta (zp_cur_target_addr),y
	iny
	sta (zp_cur_target_addr),y

	plx
	rts

