!src "memory.asm"
*=string_map_size

; first byte indicates the number of strings
!byte 16
!word .str_cow
!word .str_cat
!word .str_dog
!word .str_ant
!word .str_pig
!word .str_jellyfish
!word .str_anteater
!word .str_chicken
!word .str_seastar
!word .str_bobcat
!word .str_cougar
!word .str_jaguar
!word .str_snake
!word .str_shark
!word .str_squid
!word .str_horse

;============================================================
; Strings
;============================================================

; store the strings in !raw so that they are stored in ascii
.str_cat				!raw "cat",0
.str_dog				!raw "dog",0
.str_chicken 			!raw "chicken",0
.str_snake 				!raw "snake",0
.str_ant				!raw "ant",0
.str_anteater			!raw "anteater",0
.str_bobcat				!raw "bobcat",0
.str_cougar				!raw "cougar",0
.str_shark				!raw "shark",0
.str_squid				!raw "squid",0
.str_jaguar				!raw "jaguar",0
.str_jellyfish			!raw "jellyfish",0
.str_seastar			!raw "seastar",0
.str_pig				!raw "pig",0
.str_horse				!raw "horse",0
.str_cow				!raw "cow",0
