!ifdef TARGET_MARCROS !eof
TARGET_MARCROS = 1

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
