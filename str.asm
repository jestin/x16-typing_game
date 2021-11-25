!src "memory.asm"
*=string_map
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
.str_cat				!raw "Cat",0
.str_dog				!raw "Dog",0
.str_chicken 			!raw "Chicken",0
.str_snake 				!raw "Snake",0
.str_ant				!raw "Ant",0
.str_anteater			!raw "Anteater",0
.str_bobcat				!raw "Bobcat",0
.str_cougar				!raw "Cougar",0
.str_shark				!raw "Shark",0
.str_squid				!raw "Squid",0
.str_jaguar				!raw "Jaguar",0
.str_jellyfish			!raw "Jellyfish",0
.str_seastar			!raw "Seastar",0
.str_pig				!raw "Pig",0
.str_horse				!raw "Horse",0
.str_cow				!raw "Cow",0
