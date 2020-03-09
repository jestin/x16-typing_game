
;==================================================
; game_tick
;==================================================
game_tick:
	lda #1							; set the color to white
	ldx #1
	jsr GRAPH_set_colors

	+MoveW zp_xpos, u0				; "undraw" the previous string
	+MoveW zp_ypos, u1
	+LoadW u2, .str_hello_world
	jsr draw_string

	lda #0
	ldx #0
	jsr GRAPH_set_colors

	+IncW zp_ypos
	lda zp_ypos
	cmp #200
	bne +
	+LoadW zp_ypos, 0

+	+MoveW zp_ypos, u1
	jsr draw_string

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

