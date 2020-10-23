GAME_SCREEN = 1
SPAWN_DELAY = 100

;==================================================
; game_init
; Initializes everything needed to run the game
;==================================================
game_init:
	+LoadW zp_next_target_string_addr, target_string_data
	+LoadW zp_string_buffer_addr, string_buffer

	lda #0
	sta zp_next_sprite_index
	sta zp_score
	sta zp_missed

	; set the tick counter so that a spawn happens
	; on the first tick
	+LoadW zp_tick_counter, SPAWN_DELAY - 1

	; set video mode
	lda #%01110001		; sprites and l1 enabled
	sta veradcvideo

	jsr setup_game_bitmap
	jsr load_game_sprites
	jsr setup_game_tile_map

	ldx #0
-	cpx #NUM_TARGETS
	beq +
	jsr clear_target
	inx
	jmp -
+	nop

	lda #0
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
	+IncW zp_tick_counter

	jsr get_keyboard_input
	
	; clear the matched target count
	lda #0
	sta zp_num_matched_targets

	; loop through the targets
	ldx #0

-	jsr update_target
	inx
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
	lda zp_tick_counter+1
	cmp #>SPAWN_DELAY
	bmi +					; >zp_tick_counter is lower than >SPAWN_DELAY, skip the add
	lda zp_tick_counter
	cmp #<SPAWN_DELAY
	bmi +
	jsr add_random_target

	+LoadW zp_tick_counter, 0

+	rts

;==================================================
; setup_game_bitmap
; Load the bitmap screen background
;==================================================
setup_game_bitmap:
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
; setup_game_tile_map
; Loads the tiles and tilemap into vram, and sets
; the tile settings in the VERA.
;==================================================
setup_game_tile_map:
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

	+LoadW u0, game_map

	ldx #0
GAME_TILE_ROW_LOOP:
	ldy #0
-	lda (u0),y		; first byte is lower 8 bits of tile index
	sta veradat
	iny
	lda (u0),y		; second byte contains paloffset
	sta veradat
	iny
	cpy #0	; let it loop full circle
	bne -
	+AddW u0, 160		; only increment 80 tiles x 2 bytes per tile
	inx
	cpx #60
	bne GAME_TILE_ROW_LOOP

	rts

;==================================================
; load_game_sprites
; Loads the sprites into VRAM
;==================================================
load_game_sprites:
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
