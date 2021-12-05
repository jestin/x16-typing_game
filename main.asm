*=$1000
jmp main

!src "vera.asm"
!src "macros.asm"
!src "memory.asm"
!src "vram.asm"
!src "x16.asm"
!src "zp.asm"
!src "sprite_helpers.asm"
!src "target_macros.asm"
!src "targets.asm"
!src "target_strings.asm"
!src "math.asm"
!src "key_buffer.asm"
!src "random.asm"
!src "title.asm"
!src "game.asm"
!src "sprites.asm"

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
	beq CHECK_VSYNC_END

	; VSYNC has occurred, handle

	lda zp_screen
	cmp #TITLE_SCREEN
	bne + 
	jsr title_tick
	jmp CHECK_VSYNC_END

+	jsr game_tick

CHECK_VSYNC_END:
	stz zp_vsync_trig
	rts
