!ifdef MEMORY !eof
MEMORY = 1

; This file defines addresses for the game's memory map

; These addresses are used for storing the targets (max
; of 8). Each of targets contains a coordinate, a
; speed, and an index to the string.
!addr target_data		= $0400
