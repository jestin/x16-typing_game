;==================================================
; game_init
;==================================================
game_init:
	lda #$80
	sec
	jsr screen_set_mode

	+LoadW r0, 0
	jsr GRAPH_init
	jsr GRAPH_clear

	jsr draw_border
	jsr load_sprites

	lda #0
	ldx #0
	ldy #1
	jsr GRAPH_set_colors

	+LoadW zp_xpos, 25
	+LoadW zp_ypos, 0

	lda #0	
	sta zp_tick_counter

	rts

;==================================================
; game_tick
;==================================================
game_tick:
	+IncW zp_ypos
	lda zp_ypos
	cmp #200
	bne +
	+LoadW zp_ypos, 0

+	ldx #0
-	lda zp_ypos
	cpx #26
	bpl +
	clc
	adc #-8
+	+sprstore 4
	lda #0
	+sprstore 5
	inx
	cpx #NUM_SPRITES
	bne -

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

	; set the sprite in the sprite registers
	ldx #0
-	jsr set_sprite
	inx
	cpx #NUM_SPRITES
	bne -

	rts
	
;==================================================
; load_sprite
; Loads a sprite into vram at current location of
; veradat.  This function assumes that AUTO_INC_1
; is set.
; void load_sprite(word addr: u0, byte size: u1L)
;==================================================
load_sprite:
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
; Sets the sprite at the index given by x
; void set_sprite(byte index: x)
;==================================================
set_sprite:
	; set the sprite in the register
-	lda #(0 << 6) | (0 << 4) | 0		; height/width/paloffset
	+sprstore 7
	lda #3 << 2          ; z-depth=3
	+sprstore 6
	txa
	clc
	adc #<(sprite_vram_data >> 5)
	+sprstore 0
	lda #>(sprite_vram_data >> 5) | 0 << 7 ; mode=0
	+sprstore 1

	; Calculate the X position based on the index
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

	+sprstore 2
	lda #0
	+sprstore 3
	lda #50 							; Y of 50
	+sprstore 4
	lda #0
	+sprstore 5

	rts


!src "strings.inc"
!src "sprites.asm"
