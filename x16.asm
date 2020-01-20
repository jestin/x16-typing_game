!ifdef X16 !eof
X16 = 1

; ------------------------------------------------------------ 
; Commodore 64 API
; ------------------------------------------------------------ 

; Channel I/O
!addr SETMSG 		= $FF90 ; set verbosity 
!addr READST 		= $FFB7 ; return status byte 
!addr SETLFS 		= $FFBA ; set LA, FA and SA 
!addr SETNAM 		= $FFBD ; set filename 
!addr OPEN 			= $FFC0 ; open a channel 
!addr CLOSE 		= $FFC3 ; close a channel 
!addr CHKIN 		= $FFC6 ; set channel for character input 
!addr CHKOUT 		= $FFC9 ; set channel for character output 
!addr CLRCHN 		= $FFCC ; restore character I/O to screen/keyboard 
!addr BASIN 		= $FFCF ; get character 
!addr BSOUT 		= $FFD2 ; write character 
!addr LOAD 			= $FFD5 ; load a file into memory 
!addr SAVE 			= $FFD8 ; save a file from memory 
!addr CLALL 		= $FFE7 ; close all channels

; Commodore Peripheral Bus
!addr TALK 			= $FFB4 ; send TALK command 
!addr LISTEN 		= $FFB1 ; send LISTEN command 
!addr UNLSN 		= $FFAE ; send UNLISTEN command 
!addr UNTLK 		= $FFAB ; send UNTALK command 
!addr IECOUT 		= $FFA8 ; send byte to serial bus 
!addr IECIN 		= $FFA5 ; read byte from serial bus 
!addr SETTMO 		= $FFA2 ; set timeout 
!addr TKSA 			= $FF96 ; send TALK secondary address 
!addr SECOND 		= $FF93 ; send LISTEN secondary address

; Memory
!addr MEMBOT 		= $FF9C ; read/write address of start of usable RAM 
!addr MEMTOP 		= $FF99 ; read/write address of end of usable RAM

; Time
!addr RDTIM 		= $FFDE ; read system clock 
!addr SETTIM 		= $FFDB ; write system clock 
!addr UDTIM 		= $FFEA ; advance clock

; Other:
!addr STOP 			= $FFE1 ; test for STOP key 
!addr GETIN 		= $FFE4 ; get character from keyboard 
!addr SCREEN 		= $FFED ; get the screen resolution 
!addr PLOT 			= $FFF0 ; read/write cursor position 
!addr IOBASE 		= $FFF3 ; return start of I/O area

; ------------------------------------------------------------ 
; Commodore 128 API
; ------------------------------------------------------------ 

!addr CLOSE_ALL		= $FF4A ; close all files on a device 
!addr LKUPLA 		= $FF8D ; search tables for given LA 
!addr LKUPSA 		= $FF8A ; search tables for given SA 
!addr DLCHR 		= $FF62 ; activate a text mode font in the video hardware [not yet implemented] 
!addr PFKEY 		= $FF65 ; program a function key [not yet implemented] 
!addr FETCH 		= $FF74 ; LDA (fetvec),Y from any bank 
!addr STASH 		= $FF77 ; STA (stavec),Y to any bank 
!addr CMPARE 		= $FF7A ; CMP (cmpvec),Y to any bank 
!addr PRIMM 		= $FF7D ; print string following the caller’s code

; ------------------------------------------------------------ 
; Commander X16 API
; ------------------------------------------------------------ 

; Clock
!addr clock_set_date_time 		= $FF4D ; set date and time 
!addr clock_get_date_time 		= $FF50 ; get date and time

; Mouse
!addr mouse_config 				= $FF68 ; configure mouse pointer 
!addr mouse_get 				= $FF6B ; get state of mouse

; Joystick
!addr joystick_scan 			= $FF53 ; query joysticks 
!addr joystick_get 				= $FF56 ; get state of one joystick

; Sprites
!addr sprite_set_image 			= $FEF0 ; set the image of a sprite 
!addr sprite_set_position 		= $FEF3 ; set the position of a sprite

; Framebuffer
!addr FB_init 					= $FEF6 ; enable graphics mode 
!addr FB_get_info 				= $FEF9 ; get screen size and color depth 
!addr FB_set_palette 			= $FEFC ; set (parts of) the palette 
!addr FB_cursor_position 		= $FEFF ; position the direct;access cursor 
!addr FB_cursor_next_line 		= $FF02 ; move direct;access cursor to next line 
!addr FB_get_pixel 				= $FF05 ; read one pixel, update cursor 
!addr FB_get_pixels 			= $FF08 ; copy pixels into RAM, update cursor 
!addr FB_set_pixel 				= $FF0B ; set one pixel, update cursor 
!addr FB_set_pixels 			= $FF0E ; copy pixels from RAM, update cursor 
!addr FB_set_8_pixels 			= $FF11 ; set 8 pixels from bit mask (transparent), update cursor 
!addr FB_set_8_pixels_opaque 	= $FF14 ; set 8 pixels from bit mask (opaque), update cursor 
!addr FB_fill_pixels 			= $FF17 ; fill pixels with constant color, update cursor 
!addr FB_filter_pixels 			= $FF1A ; apply transform to pixels, update cursor 
!addr FB_move_pixels 			= $FF1D ; copy horizontally consecutive pixels to a different position

; Graphics
!addr GRAPH_init 				= $FF20 ; initialize graphics 
!addr GRAPH_clear 				= $FF23 ; clear screen 
!addr GRAPH_set_window 			= $FF26 ; set clipping region
!addr GRAPH_set_colors 			= $FF29 ; set stroke, fill and background colors 
!addr GRAPH_draw_line 			= $FF2C ; draw a line 
!addr GRAPH_draw_rect 			= $FF2F ; draw a rectangle (optionally filled) 
!addr GRAPH_move_rect 			= $FF32 ; move pixels 
!addr GRAPH_draw_oval 			= $FF35 ; draw an oval or circle 
!addr GRAPH_draw_image 			= $FF38 ; draw a rectangular image 
!addr GRAPH_set_font 			= $FF3B ; set the current font 
!addr GRAPH_get_char_size 		= $FF3E ; get size and baseline of a character 
!addr GRAPH_put_char 			= $FF41 ; print a character

; Console
!addr CONSOLE_init 					= $FEDB ; initialize console mode 
!addr CONSOLE_put_char 				= $FEDE ; print character to console 
!addr CONSOLE_put_image				= $FED8 ; draw image as if it was a character
!addr CONSOLE_get_char 				= $FEE1 ; get character from console
!addr CONSOLE_set_paging_message	= $FED5 ; set paging message or disable paging

; Other
!addr memory_fill 				= $FEE4 ; fill memory region with a byte value 
!addr memory_copy 				= $FEE7 ; copy memory region 
!addr memory_crc 				= $FEEA ; calculate CRC16 of memory region 
!addr memory_decompress 		= $FEED ; decompress LZSA2 block 
!addr monitor 					= $FF44 ; enter machine language monitor 
!addr restore_basic 			= $FF47 ; enter BASIC 
!addr screen_set_mode 			= $FF5F ; set screen mode 
!addr screen_set_charset 		= $FF62 ; activate 8x8 text mode charset


; ------------------------------------------------------------ 
; Virtual registers
; ------------------------------------------------------------ 
!addr r0		= $02
!addr r0L		= $02
!addr r0H		= $03
!addr r1		= $04
!addr r1L		= $04
!addr r1H		= $05
!addr r2		= $06
!addr r2L		= $06
!addr r2H		= $07
!addr r3		= $08
!addr r3L		= $08
!addr r3H		= $09
!addr r4		= $0a
!addr r4L		= $0a
!addr r4H		= $0b
!addr r5		= $0c
!addr r5L		= $0c
!addr r5H		= $0d
!addr r6		= $0e
!addr r6L		= $0e
!addr r6H		= $0f
!addr r7		= $10
!addr r7L		= $10
!addr r7H		= $11
!addr r8		= $12
!addr r8L		= $12
!addr r8H		= $13
!addr r9		= $14
!addr r9L		= $14
!addr r9H		= $15
!addr r10		= $16
!addr r10L		= $16
!addr r10H		= $17
!addr r11		= $18
!addr r11L		= $18
!addr r11H		= $19
!addr r12		= $1a
!addr r12L		= $1a
!addr r12H		= $1b
!addr r13		= $1c
!addr r13L		= $1c
!addr r13H		= $1d
!addr r14		= $1e
!addr r14L		= $1e
!addr r14H		= $1f
!addr r15		= $20
!addr r15L		= $20
!addr r15H		= $21

; user virtual registers (cannot be used with BASIC or floating point)
!addr u0		=$e0
!addr u0L		=$e0
!addr u0H		=$e1
!addr u1		=$e2
!addr u1L		=$e2
!addr u1H		=$e3
!addr u2		=$e4
!addr u2L		=$e4
!addr u2H		=$e5
!addr u3		=$e6
!addr u3L		=$e6
!addr u3H		=$e7
!addr u4		=$e8
!addr u4L		=$e8
!addr u4H		=$e9
!addr u5		=$ea
!addr u5L		=$ea
!addr u5H		=$eb
!addr u6		=$ec
!addr u6L		=$ec
!addr u6H		=$ed
!addr u7		=$ee
!addr u7L		=$ee
!addr u7H		=$ef
!addr u8		=$f0
!addr u8L		=$f0
!addr u8H		=$f1
!addr u9		=$f2
!addr u9L		=$f2
!addr u9H		=$f3
!addr u10		=$f4
!addr u10L		=$f4
!addr u10H		=$f5
!addr u11		=$f6
!addr u11L		=$f6
!addr u11H		=$f7
!addr u12		=$f8
!addr u12L		=$f8
!addr u12H		=$f9
!addr u13		=$fa
!addr u13L		=$fa
!addr u13H		=$fb
!addr u14		=$fc
!addr u14L		=$fc
!addr u14H		=$fd
!addr u15		=$fe
!addr u15L		=$fe
!addr u15H		=$ff
