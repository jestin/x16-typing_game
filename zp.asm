!ifdef ZP !eof
ZP = 1

!addr zp_color_addr					= $30
!addr zp_vsync_trig					= $31
!addr zp_ypos						= $32
!addr zp_tick_counter				= $34
!addr zp_next_sprite_index			= $35

; These registers are used for storing the
; addresses of targets (max of 8). Each of
; the zp_targets registers point to a
; structure in memory that contains a
; coordinate, a speed, and an index to the
; string.
!addr zp_targets					= $36 

!addr zp_next_target_string_addr	= $38
