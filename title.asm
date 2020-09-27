TITLE_SCREEN = 0

;==================================================
; title_init
; Initializes the title screen
;==================================================
title_init:

	; set video mode
	lda #%01110001		; sprites and l1 enabled
	sta veradcvideo

	jsr setup_title_tile_map

	rts

;==================================================
; title_tick
; This is the contents of the title's main loop
;==================================================
title_tick:
	; get keyboard input
	jsr GETIN
	cmp #0
	beq GET_KEYBOARD_INPUT_END
	cmp #$0d			; RETURN
	bne +

	; if RETURN is hit, load the game
	lda #GAME_SCREEN
	sta zp_screen
	jsr game_init

+	rts

;==================================================
; setup_title_tile_map
; Loads the tiles and tilemap into vram, and sets
; the tile settings in the VERA.
;==================================================
setup_title_tile_map:
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

	+LoadW u0, title_map

	ldx #0
TITLE_TILE_ROW_LOOP:
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
	bne TITLE_TILE_ROW_LOOP

	rts
