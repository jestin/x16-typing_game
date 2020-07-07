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
	lda #$80
	sec
	jsr screen_set_mode

	+LoadW r0, 0
	jsr GRAPH_init
	jsr GRAPH_clear

	jsr draw_border
	jsr load_sprites

	ldx #0
-	cpx #NUM_TARGETS
	beq +
	jsr clear_target
	inx
	jmp -

+	nop
	; jsr test_sprites
	jsr test_target

	lda #0
	ldx #0
	ldy #1
	jsr GRAPH_set_colors

	rts

;==================================================
; game_tick
; This is the contents of the game's main loop
;==================================================
game_tick:
	+IncW zp_ypos
	lda zp_ypos
	cmp #200
	bne +
	+LoadW zp_ypos, 0

+	ldx #0
; -	lda zp_ypos
; 	cpx #26
; 	bpl +
; 	clc
; 	adc #-8
; +	sta u0L
; 	lda #0
; 	sta u0H
; 	jsr set_sprite_y_pos
; 	inx
; 	cpx #NUM_SPRITES
; 	bne -

	rts

;==================================================
; draw_string
; Draws a string to the screen at the specified xy
; void draw_string(word x: u0, word y: u1, word addr: u2)
;==================================================
draw_string:
	+MoveW u0, r0		; transfer x and y to the correct
	+MoveW u1, r1       ; virtual registers for GRAPH_put_char

	lda #0				; load 0 into loop counter variable
	sta u3

-	ldy u3				; load our loop counter variable into y
	lda (u2),y			; use zero page indirect with y addressing mode
	beq +				; branch to end when a 0 is found
	jsr GRAPH_put_char
	inc u3				; increment our loop counter
	jmp -				; loop back to loading y

+	rts

;==================================================
; draw_border
; Draws the border and sets the clipping window
;==================================================
draw_border:
	lda #0
	jsr GRAPH_set_colors

	; get resolution
	jsr FB_get_info			; loads width and height into r0 and r1
	+MoveW r0, r2			; the width and height need to be in r2
	+MoveW r1, r3			; and r3 for the GRAPH_draw_rect subroutine

	; outer rect
	+LoadW r4, 0			; don't use a corner radius
	; To make the outer rectangle 2 pixels wide, we draw two rectanlges
	+LoadW r0, 0
	+LoadW r1, 0
	jsr GRAPH_draw_rect
	+IncW r0
	+IncW r1
	+DecW r2
	+DecW r2
	+DecW r3
	+DecW r3
	clc						; no reason to fill this rect
	jsr GRAPH_draw_rect

	; middle rect (fill)
	+LoadB u1L, 0 			; loop counter
	+LoadB u1H, 108			; color ( +/- 7 here will change color scheme of border)
-	lda u1H
	jsr GRAPH_set_colors
	+IncW r0
	+IncW r1
	+DecW r2
	+DecW r2
	+DecW r3
	+DecW r3
	clc						; no reason to fill this rect
	jsr GRAPH_draw_rect
	inc u1L
	dec u1H
	lda u1L
	cmp #7
	beq +
	jmp -

	; inner rect
+	lda #0
	jsr GRAPH_set_colors
	+IncW r0
	+IncW r1
	+DecW r2
	+DecW r2
	+DecW r3
	+DecW r3
	clc						; no reason to fill this rect
	jsr GRAPH_draw_rect
	+IncW r0
	+IncW r1
	+DecW r2
	+DecW r2
	+DecW r3
	+DecW r3
	clc
	jsr GRAPH_draw_rect

	+IncW r0
	+IncW r1
	+DecW r2
	+DecW r2
	+DecW r3
	+DecW r3
	jsr GRAPH_set_window

	rts

end:
	jmp *
	rts

;==================================================
; load_sprites
; Loads the sprites into VRAM
;==================================================
load_sprites:
	; enable sprites
	lda veradcvideo
	ora #$70
	sta veradcvideo
	
; 	; load the sprite into vram
	+vset sprite_vram_data | AUTO_INC_1
	+LoadW u0, sprite_data
	lda #32
	sta u1L
	ldx #0
-	jsr load_sprite
	+AddW u0, 32
	inx
	cpx #NUM_SPRITES
	bne -

	rts

;==================================================
; test_sprites
; Displays all the sprites for testing purposes
;==================================================
test_sprites:
	; set the sprite in the sprite registers
	ldx #0
-	txa				; transfer x to y, for simplicy
	tay
	jsr set_sprite

	; Calculate the X position based on the sprite index
	txa
	cmp #26
	bmi +
	clc
	adc #-26
+	asl
	asl
	asl
	clc
	adc #50 							; X of 50
	sta u0L
	lda #0
	sta u0H
	+LoadW u1, 0
	jsr set_sprite_pos

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
	+LoadW u3, 20
	ldx #0
	jsr set_target
	jsr set_target_pos

	rts
