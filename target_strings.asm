;==================================================
; Target strings are how we store the strings of
; targets.  Because we use sprites to display
; characters rather than relying on kernel string
; and character functions, the way we store them
; is quite a bit different from how you'd typically
; store strings.  First, we need to store a
; reference back to the actual string in program
; memory.  This is just a simple index that can
; be applied to string_map as an offset.  Next, we
; need to actually store a list of sprite indexes
; that are used to display this particular target
; string.  This list is terminated by a sentinel
; value that is larger than the X16's number of
; hardware sprites (128).
;
; The target strings are stored in memory as
; follows:
; ------------------------------------------------
; |00| String index                              |
; |01| Sprite index for the character            |
; | .| ""                                        |
; | .| ""                                        |
; | .| ""                                        |
; | N| Sentinel value (255 is best)              |
; ------------------------------------------------
;
; NOTE - We will also need a special sprite index
; to represent spaces.  We don't want to waste
; hardware sprites for blank spaces that do not
; display.
;==================================================

;==================================================
; set_target_string
; Given a string index, creates the sprites and
; stores the newly created sprite indexes in memory
; in a new target string structure.
; void set_target_string(out word target_string_address: u0,
;							byte string_index: x)
;==================================================
set_target_string:
	rts

;==================================================
; allocate_target_string
; Increments the zp_next_target_string_addr
; register.
; void allocate_target_string(out addr: u0,
;								byte size: u1L)
;==================================================
allocate_target_string
	; Although this is address is a word, we will
	; never use the high byte.  Target strings are
	; only N+2 bytes in memory, where N is the
	; number of characters in the string.  Since
	; each character requires one of the 128
	; sprites that the system supports, and we
	; only allow 8 targets, the most memory this
	; section will ever use is 144 bytes (unless
	; there are spaces in the target strings, but
	; even then it's a little absurd to think that
	; 112 characters will be spaces in a typing
	; game).

	; check if there is enough space left for the
	; target string

+	rts
