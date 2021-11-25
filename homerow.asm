!src "memory.asm"
*=string_map_size

; first byte indicates the number of strings
!byte 7
!word .str_j
!word .str_k
!word .str_l
!word .str_f
!word .str_d
!word .str_s
!word .str_a

;============================================================
; Strings
;============================================================

; store the strings in !raw so that they are stored in ascii
.str_j				!raw "j",0
.str_k				!raw "k",0
.str_l 			!raw "l",0
.str_f				!raw "f",0
.str_d			!raw "d",0
.str_s				!raw "s",0
.str_a				!raw "a",0
