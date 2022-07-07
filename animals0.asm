; These are dummy values, only here to keep the assembler from complaining
.org $A000
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "RODATA"

; first byte indicates the number of strings
.byte 24
.word str_cow
.word str_cat
.word str_dog
.word str_ant
.word str_pig
.word str_jellyfish
.word str_anteater
.word str_chicken
.word str_seastar
.word str_bobcat
.word str_cougar
.word str_jaguar
.word str_snake
.word str_shark
.word str_squid
.word str_horse
.word str_salmon
.word str_iguana
.word str_octopus
.word str_elephant
.word str_turtle
.word str_woodpecker
.word str_orangutan
.word str_frog

;============================================================
; Strings
;============================================================

; store the strings in .literal so that they are stored in ascii
str_cat:				.literal "cat",0
str_dog:				.literal "dog",0
str_chicken: 			.literal "chicken",0
str_snake: 				.literal "snake",0
str_ant:				.literal "ant",0
str_anteater:			.literal "anteater",0
str_bobcat:				.literal "bobcat",0
str_cougar:				.literal "cougar",0
str_shark:				.literal "shark",0
str_squid:				.literal "squid",0
str_jaguar:				.literal "jaguar",0
str_jellyfish:			.literal "jellyfish",0
str_seastar:			.literal "seastar",0
str_pig:				.literal "pig",0
str_horse:				.literal "horse",0
str_cow:				.literal "cow",0
str_salmon:				.literal "salmon",0
str_iguana:				.literal "iguana",0
str_octopus:			.literal "octopus",0
str_elephant:			.literal "elephant",0
str_turtle:				.literal "turtle",0
str_woodpecker:			.literal "woodpecker",0
str_orangutan:			.literal "orangutan",0
str_frog:				.literal "frog",0
