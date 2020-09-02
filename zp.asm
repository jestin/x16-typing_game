!ifdef ZP !eof
ZP = 1

; Because of the kernal and user virtual registers,
; we can only safely use $22-$5f for special purpose
; zero page registers.  If this is not enough,
; consider reducing the u* registers defined in
; x16.asm.

!addr zp_vsync_trig					= $30
!addr zp_next_target_index			= $31
!addr zp_tick_counter				= $32
!addr zp_active_targets				= $34
!addr zp_next_sprite_index			= $35
!addr zp_next_target_string_addr	= $36
!addr zp_cur_target_string_addr		= $38
!addr zp_cur_target_addr			= $3a
!addr zp_string_addr				= $3c
!addr zp_string_buffer_addr			= $3e
!addr zp_num_matched_targets		= $40

; The key buffer is where we keep the typed input
; because we have $60 alocated for other user
; pseudo registers (which can be reduced if needed)
; we only have 31 characters max in the keyboard buffer
!addr zp_key_buffer_length			= $41
!addr zp_key_buffer					= $42
