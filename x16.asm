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
r0		= $02
r0L		= $02
r0H		= $03
r1		= $04
r1L		= $04
r1H		= $05
r2		= $06
r2L		= $06
r2H		= $07
r3		= $08
r3L		= $08
r3H		= $09
r4		= $0a
r4L		= $0a
r4H		= $0b
r5		= $0c
r5L		= $0c
r5H		= $0d
r6		= $0e
r6L		= $0e
r6H		= $0f
r7		= $10
r7L		= $10
r7H		= $11
r8		= $12
r8L		= $12
r8H		= $13
r9		= $14
r9L		= $14
r9H		= $15
r10		= $16
r10L	= $16
r10H	= $17
r11		= $18
r11L	= $18
r11H	= $19
r12		= $1a
r12L	= $1a
r12H	= $1b
r13		= $1c
r13L	= $1c
r13H	= $1d
r14		= $1e
r14L	= $1e
r14H	= $1f
r15		= $20
r15L	= $20
r15H	= $21

