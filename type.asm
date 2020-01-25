!src "vera.asm"
!src "zp.asm"
!src "macros.asm"
!src "x16.asm"

!addr def_irq = $0000

*=$1000

main:
	lda #$80
	sec
	jsr screen_set_mode

	+LoadW r0, 0
	jsr GRAPH_init
	jsr GRAPH_clear

	jsr draw_border

	lda #0
	ldx #0
	ldy #1
	jsr GRAPH_set_colors

	+LoadW zp_xpos, 25
	+LoadW zp_ypos, 20

	lda #0	
	sta zp_tick_counter

	jsr init_irq

;==================================================
; mainloop
;==================================================
mainloop:
   wai
   jsr check_vsync
   jmp mainloop  ; loop forever

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
	cmp #185
	bne +
	+LoadW zp_ypos, 20

+	+MoveW zp_ypos, u1
	jsr draw_string

	rts

;==================================================
; init_irq
; Initializes interrupt vector
;==================================================
init_irq:
	lda IRQVec
	sta def_irq
	lda IRQVec+1
	sta def_irq+1
	lda #<handle_irq
	sta IRQVec
	lda #>handle_irq
	sta IRQVec+1
	rts

;==================================================
; handle_irq
; Handles VERA IRQ
;==================================================
handle_irq:
	; check for VSYNC
	lda veraisr
	and #$01
	beq +
	sta zp_vsync_trig
	; clear vera irq flag
	sta veraisr

+	jmp (def_irq)

;==================================================
; check_vsync
;==================================================
check_vsync:
	lda zp_vsync_trig
	beq +

	; VSYNC has occurred, handle
	jsr game_tick

	stz zp_vsync_trig
+	rts

;==================================================
; draw_string
; Draws a string to the screen at the specified xy
; void draw_string(word x: u0, word y: u1, word addr: u2)
;==================================================
draw_string:
	lda u0				; transfer x and y to the correct
	sta r0				; virtual registers for GRAPH_put_char
	lda u1
	sta r1

	lda #0				; load 0 into loop counter variable
	sta u3

-	ldy u3
	lda (u2),y
	beq +
	jsr GRAPH_put_char
	inc u3
	jmp -
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

!src "strings.inc"
