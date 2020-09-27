TITLE_SCREEN = 0

;==================================================
; title_init
; Initializes the title screen
;==================================================
title_init:
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
