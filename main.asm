.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"

	jmp main

.include "x16.inc"
.include "vera.inc"
.include "macros.inc"
.include "memory.asm"
.include "vram.asm"
.include "zp.asm"
.include "sprite_helpers.asm"
.include "target_macros.asm"
.include "targets.asm"
.include "target_strings.asm"
.include "math.asm"
.include "key_buffer.asm"
.include "random.asm"
.include "title.asm"
.include "game.asm"
.include "sprites.asm"

main:
	; load title screen
	lda #TITLE_SCREEN
	sta zp_screen
	jsr title_init

	jsr init_irq

;==================================================
; mainloop
;==================================================
mainloop:
   wai
   jsr check_vsync
   jmp mainloop  ; loop forever

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
	beq :+
	sta zp_vsync_trig
	; clear vera irq flag
	sta veraisr

:	jmp (def_irq)

;==================================================
; check_vsync
;==================================================
check_vsync:
	lda zp_vsync_trig
	beq @check_vsync_end

	; VSYNC has occurred, handle

	lda zp_screen
	cmp #TITLE_SCREEN
	bne :+ 
	jsr title_tick
	jmp @check_vsync_end

:	jsr game_tick

@check_vsync_end:
	stz zp_vsync_trig
	rts
