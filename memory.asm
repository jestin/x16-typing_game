.ifndef MEMORY_ASM
MEMORY = 1

.segment "DATA"

; This file defines addresses for the game's memory map

; These addresses are used for storing the targets (max
; of 8). Each of targets contains a coordinate, a
; speed, and an index to the string.
target_data:				.res $40

; These addresses are used for storing target strings,
; which consist of an index to a string in program
; memory, and array of sprite indexes, and a sentinel
; value.
target_string_data_size = $0100
target_string_data: 		.res target_string_data_size
target_string_data_end	= target_string_data + target_string_data_size - 1

; This is a buffer for reading string data from program memory
string_buffer:				.res $20

; digit storage for scoreboard
missed_target_digits		= $0600		; can only be at most 3 bytes
score_digits				= $0603		; can be at most 5 bytes

; original IRQ vector address
def_irq:					.res 2
last_random_byte:			.res 1

; use hiram for the strings, so I don't have to worry about allocation

string_bank				= 1

string_map_size			= $a000		; always one less than string_map to
											; account for the number of strings
string_map				= string_map_size + 1		; strings from files are loaded here

.endif ; MEMORY_ASM
