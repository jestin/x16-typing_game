!ifdef MEMORY !eof
MEMORY = 1

; This file defines addresses for the game's memory map

; These addresses are used for storing the targets (max
; of 8). Each of targets contains a coordinate, a
; speed, and an index to the string.
!addr target_data				= $0400
!addr target_data_end			= $043f

; These addresses are used for storing target strings,
; which consiste of an index to a string in program
; memory, and array of sprite indexes, and a sentinel
; value.
!addr target_string_data		= $0440
!addr target_string_data_end	= $053f
