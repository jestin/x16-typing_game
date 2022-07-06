.ifndef MEMORY_ASM
MEMORY = 1

.segment "DATA"

; This file defines addresses for the game's memory map

; These addresses are used for storing the targets (max
; of 8). Each of targets contains a coordinate, a
; speed, and an index to the string.
target_data				= $0400
target_data_end			= $043f

; These addresses are used for storing target strings,
; which consist of an index to a string in program
; memory, and array of sprite indexes, and a sentinel
; value.
target_string_data		= $0440
target_string_data_end	= $053f

; This is a buffer for reading string data from program memory
string_buffer				= $0540
string_buffer_end			= $055f

; digit storage for scoreboard
missed_target_digits		= $0600		; can only be at most 3 bytes
score_digits				= $0603		; can be at most 5 bytes

; original IRQ vector address
def_irq					= $8000		; single word
last_random_byte		= $8002		; single byte

string_map_size			= $06FF		; always one less than string_map to
											; account for the number of strings
string_map				= $0700		; strings from files are loaded here

.endif ; MEMORY_ASM
