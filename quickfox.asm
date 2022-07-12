; These are dummy values, only here to keep the assembler from complaining
.org $A000
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "RODATA"

; first byte indicates the number of strings
.byte 16
.word str_the
.word str_quick
.word str_brown
.word str_fox
.word str_jumps
.word str_over
.word str_lazy
.word str_dog

.word str_c_the
.word str_c_quick
.word str_c_brown
.word str_c_fox
.word str_c_jumps
.word str_c_over
.word str_c_lazy
.word str_c_dog

;============================================================
; Strings
;============================================================

; store the strings in .literal so that they are stored in ascii
str_the:				.literal "the",0
str_quick:				.literal "quick",0
str_brown:				.literal "brown",0
str_fox:				.literal "fox",0
str_jumps:				.literal "jumps",0
str_over:				.literal "over",0
str_lazy:				.literal "lazy",0
str_dog:				.literal "dog",0

str_c_the:				.literal "THE",0
str_c_quick:			.literal "QUICK",0
str_c_brown:			.literal "BROWN",0
str_c_fox:				.literal "FOX",0
str_c_jumps:			.literal "JUMPS",0
str_c_over:				.literal "OVER",0
str_c_lazy:				.literal "LAZY",0
str_c_dog:				.literal "DOG",0
