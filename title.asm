TITLE_SCREEN = 0

titlemapfilename: !raw "TITLEMAP.BIN"
end_titlemapfilename:

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
	beq TITLE_TICK_START_GAME
	cmp #$20			; SPACE
	beq TITLE_TICK_START_GAME

	rts					; return if no valid selection made

TITLE_TICK_START_GAME:
	; if RETURN is hit, load the game
	lda #GAME_SCREEN
	sta zp_screen
	jsr game_init

	rts

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

	; read tile file into memory
	lda #1
	ldx #8
	ldy #0
	jsr SETLFS
	lda #(end_tilefilename-tilefilename)
	ldx #<tilefilename
	ldy #>tilefilename
	jsr SETNAM
	lda #2
	ldx #<tile_vram_data
	ldy #>tile_vram_data
	jsr LOAD

	; read tile map file into memory
	lda #1
	ldx #8
	ldy #0
	jsr SETLFS
	lda #(end_titlemapfilename-titlemapfilename)
	ldx #<titlemapfilename
	ldy #>titlemapfilename
	jsr SETNAM
	lda #2
	ldx #<tile_map_vram_data
	ldy #>tile_map_vram_data
	jsr LOAD

	rts
