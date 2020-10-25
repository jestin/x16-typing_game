;==================================================
; load_tiles
; Loads the tiles from program memory into vram
; void load_tiles(word addr: u0,
;					byte tile_width: u1L,
;					byte tile_height: u1H
;					byte bpp: u2L,
;					byte tile_count: u2H,
;					word vram_lomid: u3,
;					byte vram_hi: u4L)
; tile_width and tile_height are specified as the
; VERA does, so 0 means 8 pixels and 1 means 16.
;==================================================
load_tiles:
	jsr calculate_tile_size
	sta u1L		; now that we know the size, we don't
				; need the values that were in u1

	lda #0
	sta veractl
	lda u4L
	sta verahi
	lda u3H
	sta veramid
	lda u3L
	sta veralo

	ldx #0
-	jsr load_vram

	; add the size to u0
	lda u1L
	cmp #0
	bne +
	+AddW u0, 256	; for when size is 0 (256)

+	lda u0L
	clc
	adc u1L
	sta u0L
	lda u0H
	adc #0			; take care of any carry
	sta u0H

	inx
	cpx u2H		; compare against tile_count
	bne -

	rts

;==================================================
; calculate_tile_size
; void calculate_tile_size(byte tile_width: u1L,
;							byte tile_height: u1H,
;							byte bpp: u2L,
;							byte size: a)
; tile_width and tile_height are specified as the
; VERA does, so 0 means 8 pixels and 1 means 16.
; NOTE: A will be 0 when the tilesize is 256
;==================================================
calculate_tile_size:

	; We need to calculate the byte size of each tile,
	; which is only one of 16 options.  Both width and
	; height can only be either 8 or 16 pixels, and
	; each pixel can be either 1bpp, 2bpp, 4bpp, or 8bpp.
	; As such, it's simplest to implement this as a jump
	; table.

	; I'll get the params into a structure in the form of:
	; 0 - width
	; 1 - height
	; 2-3 - color depth

	lda u2L
	asl
	ora u1H
	asl
	ora u1L

	cmp #%00000000	; 8x8x1
	bne+
	lda #8
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00000001	; 16x8x1
	bne+
	lda #16
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00000010	; 8x16x1
	bne+
	lda #16
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00000011	; 16x16x1
	bne+
	lda #32
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00000100	; 8x8x2
	bne+
	lda #16
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00000101	; 16x8x2
	bne+
	lda #32
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00000110	; 8x16x2
	bne+
	lda #32
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00000111	; 16x16x2
	bne+
	lda #64
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00001000	; 8x8x4
	bne+
	lda #32
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00001001	; 16x8x4
	bne+
	lda #64
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00001010	; 8x16x4
	bne+
	lda #64
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00001011	; 16x16x4
	bne+
	lda #128
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00001100	; 8x8x8
	bne+
	lda #64
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00001101	; 16x8x8
	bne+
	lda #128
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00001110	; 8x16x8
	bne+
	lda #128
	jmp END_CALCULATE_TILE_SIZE
+	cmp #%00001111	; 16x16x8
	bne+
	lda #0			; use 0 to represent 256

END_CALCULATE_TILE_SIZE:
	rts
