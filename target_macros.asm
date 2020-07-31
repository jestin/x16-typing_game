!ifdef TARGET_MARCROS !eof
TARGET_MARCROS = 1

;==================================================
; SetZpCurTargetAddr
; Sets the zp_cur_target_addr pseudo-register
; based on the the current x register.
; void SetZpCurTargetAddr(byte target_index: x)
;==================================================
!macro SetZpCurTargetAddr {
	; First, we need to set zp_cur_target_addr
	; We do this by successively adding two bytes to
	; to target_data, one time for each index past 0.
	+LoadW zp_cur_target_addr, target_data
-	cpx #0
	beq +
	+AddW zp_cur_target_addr, 8
	dex
	jmp -
+	nop			; meh, I'll waste a couple cycles for readability
}

;==================================================
; SetZpCurTargetStringAddr
; Sets the zp_cur_target_addr and
; zp_cur_target_string_addr pseudo-registers
; based on the the current x register.
; void SetZpCurTargetStringAddr(byte target_index: x)
;==================================================
!macro SetZpCurTargetStringAddr {
	+SetZpCurTargetAddr

	; At this point, zp_cur_target_addr is set to the correct address,
	; so we should set zp_cur_target_string_addr.

	ldy #6
	lda (zp_cur_target_addr),y
	sta zp_cur_target_string_addr
	iny
	lda (zp_cur_target_addr),y
	sta zp_cur_target_string_addr+1
}
