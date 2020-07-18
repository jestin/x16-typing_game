;==================================================
; game_init
; Initializes everything needed to run the game
;==================================================
game_init:
	+LoadW zp_ypos, 0
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

+	nop
	jsr test_target

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

	; loop through the targets
	ldx #0

-	txa
	asl
	asl
	asl
	tay

	; load the x high byte
	iny	; increment to get x high
	lda target_data,y

	; only update the position if the target exists
	cmp #$ff
	beq +
	jsr update_target_pos
	jsr set_target_pos

+	inx
	cpx #8
	bne -


	rts

;==================================================
; setup_bitmap
; Load the bitmap screen background
;==================================================
setup_bitmap:
	; set the tile mode	
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

	; set the pallet offset
	lda #(9 << 4)
	sta u0

	; write a corner peice
	lda #0
	sta veradat
	lda u0
	sta veradat
	
	; write 78 edges
	ldx #0
-	lda #2
	sta veradat
	lda u0
	sta veradat
	inx
	cpx #78
	bne -

	; write a corner peice
	lda #0
	sta veradat
	lda u0
	ora #%00000100	; h-flip
	sta veradat

	; write blank tiles to fill the full 128 width
	ldx #0
-	lda #3
	sta veradat
	lda u0
	sta veradat
	inx
	cpx #48
	bne -

	; write 30 rows of just side edges
	ldy #0

EMPTY_ROW:
	; write an edge peice
	lda #1
	sta veradat
	ora #%0000100	; h-flip
	lda u0
	sta veradat
	
	; write 78 empties
	ldx #0
-	lda #3
	sta veradat
	lda u0
	sta veradat
	inx
	cpx #78
	bne -

	; write an edge peice
	lda #1
	sta veradat
	lda u0
	ora #%00000100	; h-flip
	sta veradat

	; write blank tiles to fill the full 128 width
	ldx #0
-	lda #3
	sta veradat
	lda u0
	sta veradat
	inx
	cpx #48
	bne -

	iny
	cpy #58
	bne EMPTY_ROW

	; write a corner peice
	lda #0
	sta veradat
	lda u0
	ora #%00001000	; v-flip
	sta veradat
	
	; write 78 edges
	ldx #0
-	lda #2
	sta veradat
	lda u0
	ora #%00001000	; v-flip
	sta veradat
	inx
	cpx #78
	bne -

	; write a corner peice
	lda #0
	sta veradat
	lda u0
	ora #%00001100	; v-flip, h-flip
	sta veradat

	; write blank tiles to fill the full 128 width
	ldx #0
-	lda #3
	sta veradat
	lda u0
	sta veradat
	inx
	cpx #48
	bne -

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


;==================================================
; test_target
; Creates a test target
;==================================================
test_target:
	ldx #0
	jsr set_target_string
	+LoadW u1, 75
	+LoadW u2, 50
	+LoadW u3, 15
	ldx #0
	jsr set_target
	jsr set_target_pos

	ldx #1
	jsr set_target_string
	+LoadW u1, 85
	+LoadW u2, 60
	+LoadW u3, 20
	ldx #1
	jsr set_target
	jsr set_target_pos

	rts
