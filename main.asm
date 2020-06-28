*=$1000
jmp main

!src "vera.asm"
!src "macros.asm"
!src "x16.asm"
!src "zp.asm"
!src "strings.inc"
!src "sprites.asm"
!src "sprite_helpers.asm"
!src "targets.asm"
!src "game.asm"

!addr def_irq = $0000

main:
	jsr game_init

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
	beq +

	; VSYNC has occurred, handle
	jsr game_tick

	stz zp_vsync_trig
+	rts
