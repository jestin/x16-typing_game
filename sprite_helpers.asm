;==================================================
; load_vram
; Loads data into vram at current location of
; veradat.  This function assumes that AUTO_INC_1
; is set.
; void load_vram(word addr: u0, byte size: u1L)
; NOTE: 0 should be use to represent a size of 256
;==================================================
load_vram:
	phy

	ldy #0
:	lda (u0),y
	sta veradat
	iny
	cpy u1L
	bne :-

	ply
	rts
	
;==================================================
; set_sprite
; Sets the sprite register at the index given by x
; to the sprite data at the index given by y.
; void set_sprite(byte sprite_index: x,
;					byte vram_index: y,
;					byte paloffset: u0L)
;==================================================
set_sprite:
	; set the sprite in the register
	lda #(SPRITE_SIZE_8 << 6) | (SPRITE_SIZE_8 << 4) | 0		; height/width/paloffset
	ora u0L
	sprstore 7
	lda #2 << 2          ; z-depth=2
	sprstore 6
	tya
	clc
	adc #<(sprite_vram_data >> 5)
	sprstore 0
	lda #>(sprite_vram_data >> 5) | 0 << 7 ; mode=0
	sprstore 1

	rts

;==================================================
; set_sprite_pos
; Sets the sprite register at the index given by x
; to the screen x,y given by u0 and u1,
; respectively.
; void set_sprite_pos(byte sprite_index: x,
;					word x_position: u0,
;					word y_position: u1)
;==================================================
set_sprite_pos:
	lda u0L
	sprstore 2
	lda u0H
	sprstore 3
	lda u1L
	sprstore 4
	lda u1H
	sprstore 5
	rts

;==================================================
; set_sprite_x_pos
; Sets the sprite register at the index given by x
; to the screen x,y given by u0 and u1,
; respectively.
; void set_sprite_pos(byte sprite_index: x,
;					word x_position: u0)
;==================================================
set_sprite_x_pos:
	lda u0L
	sprstore 2
	lda u0H
	sprstore 3
	rts

;==================================================
; set_sprite_y_pos
; Sets the sprite register at the index given by x
; to the screen x,y given by u0 and u1,
; respectively.
; void set_sprite_pos(byte sprite_index: x,
;					word Y_position: u0)
;==================================================
set_sprite_y_pos:
	lda u0L
	sprstore 4
	lda u0H
	sprstore 5
	rts

;==================================================
; clear_sprite
; Disables the sprite so that it does not draw
; void clear_sprite(byte sprite_index: x)
;==================================================
clear_sprite:
	lda #0
	sprstore 0
	sprstore 1
	sprstore 2
	sprstore 3
	sprstore 4
	sprstore 5
	sprstore 6
	sprstore 7

	rts

;==================================================
; inc_next_sprite_index
; Increments the zp_next_sprite_index register
; void inc_next_sprite_index()
;==================================================
inc_next_sprite_index:
	inc zp_next_sprite_index
	lda zp_next_sprite_index
	cmp #(128 - NUM_SCOREBOARD_SPRITES)				; some sprites display the missed and score
	bmi @return
	lda #0
	sta zp_next_sprite_index
@return:
	rts
