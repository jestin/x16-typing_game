;==================================================
; load_vram
; Loads data into vram at current location of
; veradat.  This function assumes that AUTO_INC_1
; is set.
; void load_vram(word addr: u0, byte size: u1L)
; NOTE: 0 should be use to represent a size of 256
;==================================================
load_vram:
	tya
	pha

	ldy #0
-	lda (u0),y
	sta veradat
	iny
	cpy u1L
	bne -

	pla
	tay
	rts
	
;==================================================
; set_sprite
; Sets the sprite register at the index given by x
; to the sprite data at the index given by y.
; void set_sprite(byte sprite_index: x,
;					byte vram_index: y)
;==================================================
set_sprite:
	; set the sprite in the register
-	lda #(0 << 6) | (0 << 4) | 0		; height/width/paloffset
	+sprstore 7
	lda #2 << 2          ; z-depth=2
	+sprstore 6
	tya
	clc
	adc #<(sprite_vram_data >> 5)
	+sprstore 0
	lda #>(sprite_vram_data >> 5) | 0 << 7 ; mode=0
	+sprstore 1

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
	+sprstore 2
	lda u0H
	+sprstore 3
	lda u1L
	+sprstore 4
	lda u1H
	+sprstore 5
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
	+sprstore 2
	lda u0H
	+sprstore 3
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
	+sprstore 4
	lda u0H
	+sprstore 5
	rts

;==================================================
; inc_next_sprite_index
; Increments the zp_next_sprite_index register
; void inc_next_sprite_index()
;==================================================
inc_next_sprite_index:
	inc zp_next_sprite_index
	lda #128
	cmp zp_next_sprite_index
	bne +
	lda #0
	sta zp_next_sprite_index
+	rts
