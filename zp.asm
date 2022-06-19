.ifndef ZP_ASM
ZP = 1

; Because of the kernal and user virtual registers,
; we can only safely use $22-$5f for special purpose
; zero page registers.  If this is not enough,
; consider reducing the u* registers defined in
; x16.asm.

; the score needs to be a word, since we want larger values
zp_score						= $22

; the number of missed can be a byte, because I don't
; anticipate needing even 255 allowed missed targets
zp_missed						= $24

zp_screen						= $29
zp_vsync_trig					= $30
zp_next_target_index			= $31
zp_tick_counter				= $32
zp_active_targets				= $34
zp_next_sprite_index			= $35
zp_next_target_string_addr	= $36
zp_cur_target_string_addr		= $38
zp_cur_target_addr			= $3a
zp_string_addr				= $3c
zp_string_buffer_addr			= $3e
zp_num_matched_targets		= $40

; The key buffer is where we keep the typed input
; because we have $60 alocated for other user
; pseudo registers (which can be reduced if needed)
; we only have 31 characters max in the keyboard buffer
zp_key_buffer_length			= $41
zp_key_buffer					= $42

.endif ; ZP_ASM
