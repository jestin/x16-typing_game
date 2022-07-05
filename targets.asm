NUM_TARGETS = 8

.segment "CODE"

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
; update_target
; Updates the target
; void update_targe(byte target_index: x)
;==================================================
update_target:
	txa
	asl
	asl
	asl
	tay

	; at this point, y is the offset that takes us to the
	; beginning of the target selected by x

	; load the x high byte
	iny	; increment to get x high
	lda target_data,y

	; only update the position if the target exists
	cmp #$ff
	beq UPDATE_TARGET_END

	iny	; increment twice to get y high
	iny
	lda target_data,y
	cmp #$01
	bne :+
	dey ; decrement to get y low
	lda target_data,y
	cmp #$a0				; clear targets at 416
	bcc :+

	; At this point, the player has missed the target
	; TODO: apply whatever penalty occurs
	inc zp_missed

	jsr clear_target
	jsr clear_target_sprites
	jmp UPDATE_TARGET_END

:	jsr update_target_chars
	jsr update_target_pos
	jsr set_target_pos

UPDATE_TARGET_END:
	rts

;==================================================
; update_target_pos
; Update the target's x and y coordinates
; void update_target_pos(byte target_index: x)
;==================================================
update_target_pos:
	phy
	phx

	SetZpCurTargetAddr

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
	bne :+ 			; if not equal, do not update position

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
	bne :+				; when zero is set, it means rollover

	; increment the high byte
	iny
	lda (zp_cur_target_addr),y
	inc
	sta (zp_cur_target_addr),y

:	lda u0H			; load the temp var for tick count,
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

	SetZpCurTargetStringAddr

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
	inx
	lda string_map,x
	sta zp_string_addr+1

	; zp_string_addr now points to the program memory that
	; holds the actual string

	; store the paloffset to use, defaulting to 0
	lda #0
	sta u0L

	; loop through the buffer and compare against current char
	ldy #$ff	; because we start with an increment, we initialize to $ff
:	iny
	lda (zp_string_addr),y
	cmp #0									; null-terminated string
	beq UPDATE_TARGET_CHARS_COMPLETE_MATCH
	cpy zp_key_buffer_length
	beq :+
	lda #3		; paloffset
	sta u0L
	lda (zp_string_addr),y
	cmp zp_key_buffer,y	
	beq :-

	; if we make it here, it means the string doesn't match
	lda #0
	sta u0L

	; loop through the sprites and change the pallete offset
:	ldy #1			; the sprite indices start at byte 1
:	lda (zp_cur_target_string_addr),y
	cmp #255		; compare to sentinel value
	beq UPDATE_TARGET_MATCH_CHECK
	tax
	lda #((SPRITE_SIZE_8 << 6) | (SPRITE_SIZE_8 << 4) | 0)		; height/width/paloffset
	ora u0L														; OR with paloffset
	sprstore 7
	cpy zp_key_buffer_length
	beq UPDATE_TARGET_MATCH_CHECK
	iny
	jmp :-

UPDATE_TARGET_CHARS_COMPLETE_MATCH:
	; this is for when the full string has been matched

	; update score
	clc
	lda zp_score
	adc zp_key_buffer_length
	sta zp_score
	bcc :+
	inc zp_score+1				; on carry increment high byte
	
:	plx
	jsr clear_target
	jsr clear_target_sprites
	lda #0
	sta zp_key_buffer_length
	ply
	rts

UPDATE_TARGET_MATCH_CHECK:
	; check if anything was highlighted
	lda u0L
	cmp #0				; non-highlighted paloffset
	beq UPDATE_TARGET_CHARS_END

	; increment the matched target count
	lda zp_num_matched_targets
	inc
	sta zp_num_matched_targets

UPDATE_TARGET_CHARS_END:
	plx
	ply

	rts

;==================================================
; set_target_pos
; Update the sprite positions of the target's string.
; void set_target_pos(byte target_index: x)
;==================================================
set_target_pos:
	phx

	SetZpCurTargetStringAddr

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
:	lda (zp_cur_target_string_addr),y
	cmp #255		; compare to sentinel value
	beq :+
	tax
	jsr set_sprite_pos
	iny
	AddW u0, 8
	jmp :-

:	plx				; restore X
	rts

;==================================================
; clear_target_sprites
; Clears the target's sprites.
; void clear_target_sprites(byte target_index: x)
;==================================================
clear_target_sprites:
	phx

	SetZpCurTargetStringAddr

	ldy #1			; the sprite indices start at byte 1
:	lda (zp_cur_target_string_addr),y
	cmp #255		; compare to sentinel value
	beq :+
	tax
	jsr clear_sprite
	iny
	jmp :-

:	nop

	plx
	rts

;==================================================
; clear_target
; Clears a target, by setting the string address
; to a sentinel value.
; void clear_target(byte target_index: x)
;==================================================
clear_target:
	phy
	phx

	SetZpCurTargetAddr

	; set the X value to $FFFF, which we will interpret as null
	ldy #0
	lda #255
	sta (zp_cur_target_addr),y
	iny
	sta (zp_cur_target_addr),y

	; decrement active targets
	dec zp_active_targets

	plx
	ply
	rts

;==================================================
; add_random_target
; Adds a random target
; void add_random_target()
;==================================================
add_random_target:
	; loop through the targets to find the next available index
	ldx #$ff	; increment first

:	inx
	txa
	asl
	asl
	asl
	tay

	; at this point, y is the offset that takes us to the
	; beginning of the target selected by x

	; load the x high byte
	iny	; increment to get x high
	lda target_data,y

	; if not $ff, try the next one
	cmp #$ff
	bne :-

	; compare x to make sure we didn't go through all the targets without finding any
	cpx #8
	bmi :+
	rts		; if here, we just return without adding

:	txa
	sta zp_next_target_index

	; check the size of the the string map and get an appropriate random value
	lda string_map_size
	jsr get_random_byte_less_than

	tax
	jsr set_target_string

	; y contains the string's length knowing that each character is 8 pixels,
	; we need to choose a reasonable random x value such that the string doesn't
	; go off the screen

	; random x coordinate
	jsr get_random_byte		; low byte is full byte
	sta u1L
	jsr get_random_nibble
	lsr
	lsr
	lsr
	clc
	sta u1H					; high byte is either $00 or $01
	AddW u1, 16			; add enough to make sure it's off the left edge

	LoadW u2, 0	; y of 0
	jsr get_random_medium_speed
	sta u3L
	ldx zp_next_target_index
	jsr set_target
	jsr set_target_pos

	; increment active targets
	inc zp_active_targets

	rts
