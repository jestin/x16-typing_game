;==================================================
; game_init
; Initializes everything needed to run the game
;==================================================
game_init:
	+LoadW zp_next_target_string_addr, target_string_data
	+LoadW zp_string_buffer_addr, string_buffer

	lda #0
	sta zp_next_sprite_index

	lda #0	
	sta zp_tick_counter

	; set video mode
	lda #%01110001		; sprites and l1 enabled
	sta veradcvideo

	jsr setup_bitmap
	jsr load_sprites
	jsr setup_tile_map

	ldx #0
-	cpx #NUM_TARGETS
	beq +
	jsr clear_target
	inx
	jmp -

+	lda #0
	sta zp_next_target_index
	sta zp_active_targets

	lda #0
	sta zp_key_buffer_length

	rts

;==================================================
; game_tick
; This is the contents of the game's main loop
;==================================================
game_tick:
	; update the tick counter
	lda zp_tick_counter
	inc
	sta zp_tick_counter

	jsr get_keyboard_input
	
	; clear the matched target count
	lda #0
	sta zp_num_matched_targets

	; loop through the targets
	ldx #0

-	txa
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
	beq +
	jsr update_target_chars
	jsr update_target_pos
	jsr set_target_pos

+	inx
	cpx #8
	bne -

	; clear key buffer if no matches
	lda zp_num_matched_targets
	cmp #0
	bne +
	lda #0
	sta zp_key_buffer_length

	; add new target if needed
+	lda zp_active_targets
	cmp #8
	bpl +
	jsr add_random_target

+	rts

;==================================================
; setup_bitmap
; Load the bitmap screen background
;==================================================
setup_bitmap:
	; set the bitmap mode	
	lda #%00000101 	; height (2-bits) - 0
					; width (2-bits) - 2
					; T256C - 0
					; bitmap mode - 0
					; color depth (2-bits) - 1 (2bbp)
	sta veral0config

	; set the pallet offset
	lda #12
	sta veral0hscrollhi

	; set the tile base address	(320 width)
	lda #(<(bitmap_base_data >> 9) | (0 << 2) | 0)
								;  height    |  width

	sta veral0tilebase

	+vset bitmap_base_data | AUTO_INC_1

	ldy #0
BITMAP_ROWS:

	ldx #0
-	lda #(1 << 6 | 3 << 4 | 1 << 2 | 3)
	sta veradat
	inx
	cpx #160	; two rows of 320 pixels at 2bpp
	bne -

	iny
	cpy #240	; number of rows / 2
	bne BITMAP_ROWS

	rts

;==================================================
; setup_tile_map
; Loads the tiles and tilemap into vram, and sets
; the tile settings in the VERA.
;==================================================
setup_tile_map:
	; set the tile mode	
	lda #%01100010 	; height (2-bits) - 0
					; width (2-bits) - 2
					; T256C - 0
					; bitmap mode - 0
					; color depth (2-bits) - 2 (4bbp)
	sta veral1config

	; set the tile map base address
	lda #<(tile_map_vram_data >> 9)
	sta veral1mapbase

	; set the tile base address
	lda #(<(tile_vram_data >> 9) | %00000000 | %00000000)
								;  height    |  width
	sta veral1tilebase


	; load the tiles
	lda #0
	sta u1L		; 8 pixel width
	sta u1H		; 8 pixel height
	lda #2
	sta u2L		; 4bpp
	lda #NUM_TILES
	sta u2H		; number of tiles
	lda #<(tile_data)
	sta u0L
	lda #>(tile_data)
	sta u0H
	jsr load_tiles

	; fill the base map
	+vset tile_map_vram_data | AUTO_INC_1

	+LoadW u0, basic_map
	lda #($9 << 4)				; palette offset
	sta u1L

	ldx #0
TILE_ROW_LOOP:
	ldy #0
-	lda (u0),y		; first byte is lower 8 bits of tile index
	sta veradat
	iny
	lda (u0),y		; second byte contains paloffset
	ora u1L			; or with paloffset
	sta veradat
	iny
	cpy #0	; let it loop full circle
	bne -
	+AddW u0, 160		; only increment 80 tiles x 2 bytes per tile
	inx
	cpx #60
	bne TILE_ROW_LOOP

	rts

;==================================================
; load_sprites
; Loads the sprites into VRAM
;==================================================
load_sprites:
; 	; load the sprite into vram
	+vset sprite_vram_data | AUTO_INC_1
	+LoadW u0, sprite_data
	lda #32
	sta u1L
	ldx #0
-	jsr load_vram
	+AddW u0, 32
	inx
	cpx #NUM_SPRITES
	bne -

	rts
