!ifdef ZP !eof
ZP = 1

; Because of the kernal and user virtual registers,
; we can only safely use $22-$5f for special purpose
; zero page registers.  If this is not enough,
; consider reducing the u* registers defined in
; x16.asm.

!addr zp_color_addr					= $30
!addr zp_vsync_trig					= $31
!addr zp_ypos						= $32
!addr zp_tick_counter				= $34
!addr zp_next_sprite_index			= $35

!addr zp_next_target_string_addr	= $38
