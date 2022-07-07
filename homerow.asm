; These are dummy values, only here to keep the assembler from complaining
.org $A000
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "RODATA"

; first byte indicates the number of strings
.byte 7
.word str_j
.word str_k
.word str_l
; .word str_semi
.word str_f
.word str_d
.word str_s
.word str_a

;============================================================
; Strings
;============================================================

; store the strings in .literal so that they are stored in ascii
str_j:				.literal "j",0
str_k:				.literal "k",0
str_l: 				.literal "l",0
; str_semi:			.literal ";",0
str_f:				.literal "f",0
str_d:				.literal "d",0
str_s:				.literal "s",0
str_a:				.literal "a",0
