GAME_SCREEN = 1
SPAWN_DELAY = 100
END_ON_MISEED = 11
MAX_FILE_SIZE = 1000
.file_buffer !word MAX_FILE_SIZE

stringfilename: !raw "ANI0.BIN"
end_stringfilename:

tilefilename: !raw "TILES.BIN"
end_tilefilename:

gamemapfilename: !raw "GAMEMAP.BIN"
end_gamemapfilename:

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
	sta zp_score+1
	sta zp_missed

	; set the tick counter so that a spawn happens
	; on the first tick
	+LoadW zp_tick_counter, SPAWN_DELAY - 1

	; clear sprites
	ldx #0
-	jsr clear_sprite
	inx
	cpx #$7f
	bne -

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

	; read string file into memory
	lda #1
	ldx #8
	ldy #0
	jsr SETLFS
	lda #(end_stringfilename-stringfilename)
	ldx #<stringfilename
	ldy #>stringfilename
	jsr SETNAM
	lda #0
	ldx #<string_map_size
	ldy #>string_map_size
	jsr LOAD

	rts

;==================================================
; game_tick
; This is the contents of the game's main loop
;==================================================
game_tick:
	; update the tick counter
	+IncW zp_tick_counter

	jsr set_scoreboard

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

	; end game on too many missed targets
	lda zp_missed
	cmp #END_ON_MISEED
	bcc +
	lda #TITLE_SCREEN
	sta zp_screen
	jsr title_init

	; clear key buffer if no matches
+	lda zp_num_matched_targets
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
	lda #%00000110 	; height (2-bits) - 0
					; width (2-bits) - 0
					; T256C - 0
					; bitmap mode - 1
					; color depth (2-bits) - 2 (4bpp)
	sta veral0config

	; set the pallet offset
	lda #0
	sta veral0hscrollhi

	; set the bitmap base address	(320 width)
	lda #(<(bitmap_base_data >> 9) | (0 << 2) | 0)
								;  height    |  width
	sta veral0tilebase

	+vset bitmap_base_data | AUTO_INC_1

	ldy #0
BITMAP_ROWS:
	+LoadW u0, 0		; x

-	lda #$06			; black|blue

	; check whether to use white background
	cpy #210
	bcc + 	
	lda #$11			; white|white

+	sta veradat
	+IncW u0
	lda u0L
	cmp #<320
	bne -
	lda u0H
	cmp #>320
	bne -

	iny
	cpy #240
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
					; color depth (2-bits) - 2 (4bpp)
	sta veral1config

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

	; set the tile map base address
	lda #<(tile_map_vram_data >> 9)
	sta veral1mapbase

	; read tile map file into memory
	lda #1
	ldx #8
	ldy #0
	jsr SETLFS
	lda #(end_gamemapfilename-gamemapfilename)
	ldx #<gamemapfilename
	ldy #>gamemapfilename
	jsr SETNAM
	lda #2
	ldx #<tile_map_vram_data
	ldy #>tile_map_vram_data
	jsr LOAD

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

	; initialize scoreboard sprites

	; missed lo digit
	ldx #(128 - NUM_SCOREBOARD_SPRITES)
	ldy #52
	lda #1				; paloffset
	sta u0L
	jsr set_sprite
	+LoadW u0, 180
	+LoadW u1, 440
	jsr set_sprite_pos

	; missed mid digit
	ldx #(128 - NUM_SCOREBOARD_SPRITES) + 1
	lda #1				; paloffset
	sta u0L
	jsr set_sprite
	+LoadW u0, 172
	+LoadW u1, 440
	jsr set_sprite_pos

	; missed hi digit
	ldx #(128 - NUM_SCOREBOARD_SPRITES) + 2
	lda #1				; paloffset
	sta u0L
	jsr set_sprite
	+LoadW u0, 164
	+LoadW u1, 440
	jsr set_sprite_pos

	; score lo digit
	ldx #(128 - NUM_SCOREBOARD_SPRITES) + 3
	lda #1				; paloffset
	sta u0L
	jsr set_sprite
	+LoadW u0, 476
	+LoadW u1, 440
	jsr set_sprite_pos

	; score second lowest digit
	ldx #(128 - NUM_SCOREBOARD_SPRITES) + 4
	lda #1				; paloffset
	sta u0L
	jsr set_sprite
	+LoadW u0, 468
	+LoadW u1, 440
	jsr set_sprite_pos

	; score mid digit
	ldx #(128 - NUM_SCOREBOARD_SPRITES) + 5
	lda #1				; paloffset
	sta u0L
	jsr set_sprite
	+LoadW u0, 460
	+LoadW u1, 440
	jsr set_sprite_pos

	; score second highest digit
	ldx #(128 - NUM_SCOREBOARD_SPRITES) + 6
	lda #1				; paloffset
	sta u0L
	jsr set_sprite
	+LoadW u0, 452
	+LoadW u1, 440
	jsr set_sprite_pos

	; score hi digit
	ldx #(128 - NUM_SCOREBOARD_SPRITES) + 7
	lda #1				; paloffset
	sta u0L
	jsr set_sprite
	+LoadW u0, 444
	+LoadW u1, 440
	jsr set_sprite_pos

	rts

;==================================================
; set_scoreboard
; Sets the sprites for the scoreboard
;==================================================
set_scoreboard:

	+LoadW u0, missed_target_digits

	; clear old data
	ldx #NUM_SCOREBOARD_SPRITES
-	lda #0
	sta missed_target_digits,x
	dex
	bne -

	lda zp_missed
	jsr decimal_chars_8
	tya
	sta u2L				; number of digits

	+LoadW u0, score_digits
	lda zp_score
	sta u1L
	lda zp_score+1
	sta u1H
	jsr decimal_chars_16
	tya
	sta u2H				; number of digits

	+LoadW u1, missed_target_digits			; since u0 is needed for set_sprite, load u1 with the same address

	ldy #0
	; scoreboard uses the last 8 sprites
	ldx #(128 - NUM_SCOREBOARD_SPRITES)

-	lda (u1),y
	phy					; save the current y, since set_sprite uses it
	clc
	adc #52				; the start of the number sprites
	tay
	lda #1				; paloffset
	sta u0L
	jsr set_sprite
	ply					; restore y
	iny
	inx
	cpx #128
	bne -

	rts
