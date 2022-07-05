.segment "CODE"

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
; TODO - We will also need a special sprite index
; to represent spaces.  We don't want to waste
; hardware sprites for blank spaces that do not
; display.  Currently, this does not support spaces.
;==================================================

;==================================================
; set_target_string
;
; Given a string index, creates the sprites and
; stores the newly created sprite indexes in memory
; in a new target string structure.
;
; void set_target_string(out word target_string_address: u0,
;							out byte string_length: y,
;							byte string_index: x)
;==================================================
set_target_string:
	; Copy the address of the string into zp_string_addr
	; so that we can use zp indirect addressing.  First
	; we need to left shift x to multiply by two, since
	; each string in the map is 2 bytes.  This limits us
	; to 128 strings total, since x is only 8 bit.
	txa
	pha			; push the original x to the stack
	asl
	tax

	; Now string_map,x is an address that points to
	; program memory containing the string we want.
	; We can use absolute addressing to read it.
	lda string_map,x
	sta zp_string_addr
	inx
	lda string_map,x
	sta zp_string_addr + 1

	; at this point, the address of the string we
	; want is stored in zp_string_addr.  We can
	; now use zp indirect y addressing to read
	; individual bytes.

	; store previous next sprite index, before changing it by allocating
	lda zp_next_sprite_index
	sta u6L

	ldy #0		; zero out the y register

@read_string_loop:
	lda (zp_string_addr),y
	cmp #0
	beq @end_read_string_loop	; end of string
	
	; At this point we have an ascii code to allocate
	; a sprite for.  The sprites are allocated as
	; uppercase (0-25) and lowercase (26-51).  This
	; means that for uppcase numbers we need to subtract
	; 65 in order to get the correct index, but for
	; lowercase we need to subtract 71 (97-26).

	sec
	sbc #65			; subtract 65 no matter what
	cmp #26			; anything above 25 is lowercase
	bmi :+			; branch to skip right to sprite allocation
	sec
	sbc #6			; subtract an additional 6 for lowercase
					; this represents the characters between
					; upper and lower in ascii

	; At this point A stores the sprite vram index.
	
:	sta (zp_string_buffer_addr),y		; store in the temp string buffer
	tya
	sta u1			; stash loop counter in a pseudo register
	; load sprite vram index into y
	lda (zp_string_buffer_addr),y
	tay
	; load the next vera sprite index into x
	ldx zp_next_sprite_index
	lda #0
	sta u0L
	jsr set_sprite
	
	lda u1			; restore the loop counter
	tay

	; At this point, the sprite has been set in the VERA
	; but we still need to store it in the target string
	; memory structure.  This will be done out of the loop
	; so that we can properly allocate target string memory.

	iny
	jsr inc_next_sprite_index
	
	jmp @read_string_loop

@end_read_string_loop:

	; We need to allocate the next target string.
	; This puts the address in u0, which is where
	; it needs to be at the end of this subroutine.
	tya			; should be the length of the string
	sta u1L
	jsr allocate_target_string
	MoveW u0, zp_cur_target_string_addr

	pla			; pull the original x from the stack
	tax

	; write the target string data
	lda #0
	tay
	txa			; the string index
	sta (zp_cur_target_string_addr),y

	; We need to write the sprite indices, but we've already
	; incremented the next sprite counter.  So, we will
	; subtract the length of the string from the current
	; counter, and increment it as we write.

; 	lda zp_next_sprite_index
; 	sec
; 	sbc u1L
; 	bcs +
; 	clc				; if carry is clear, it means we rolled over, so
; 	adc #128		; add 128 to put us back in the 0-127 range
; +	sta u2L

@write_target_string_loop:
	cpy u1L
	bcs @write_target_string_sentinel
	lda u6L
	iny
	sta (zp_cur_target_string_addr),y
	inc u6L
	lda u6L
	cmp #(128 - NUM_SCOREBOARD_SPRITES)		; just like with zp_next_sprite_index, we need to cap at 127
	bmi :+
	lda #0
	sta u6L
:	jmp @write_target_string_loop

@write_target_string_sentinel:
	lda #255		; sentinel value
	iny
	sta (zp_cur_target_string_addr),y

	rts

;==================================================
; allocate_target_string
;
; Increments the zp_next_target_string_addr
; register.  This function requires the size of the
; string (just the number of characters, without
; terminating 0) and will return the allocated
; address.
;
; void allocate_target_string(out addr: u0,
;								byte size: u1L)
;==================================================
allocate_target_string:

; Although this address is a word, we will
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

	MoveW zp_next_target_string_addr, u0	; store current in out variable
	MoveW zp_next_target_string_addr, u2	; use u2 to compute new next

	; this will account for the index and sentinel
	AddW u2, 2

	; calculate new next
	lda u2L
	clc
	adc u1L
	sta u2L
	lda u2H
	adc #0		; carry
	sta u2H

	MoveW u2, zp_next_target_string_addr

	; the high byte is still in the accumulator
	cmp #>target_string_data_end
	bcc :+		; the high byte of the new address is lower,
				; so we are within range
	
	; if we are here, we need to check the low byte
	lda u2L
	cmp #<target_string_data_end
	bmi :+		; the low byte of the new address is lower,
				; so we are within range

	; if we are here, we need to return the start of the target string block
	; and advance the next to the length plus two
	LoadW u0, target_string_data
	LoadW zp_next_target_string_addr, target_string_data
	AddW zp_next_target_string_addr, 2			; for sentinel and index

	lda zp_next_target_string_addr
	clc
	adc u1L
	sta zp_next_target_string_addr
	lda zp_next_target_string_addr+1
	adc #0	; carry
	sta zp_next_target_string_addr+1

:	rts
