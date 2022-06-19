NAME = TYPE
ASSEMBLER6502 = cl65
ASFLAGS = -t cx16 -l $(NAME).list

ACME	= acme
ACME_FLAGS		= -f cbm -DMACHINE_C64=0 -Wtype-mismatch --cpu w65c02

PROG = $(NAME).PRG
LIST = $(NAME).list
MAIN = main.asm
SOURCES = $(MAIN) \
		  x16.inc \
		  vera.inc

WORD_FILES		= ANI0.BIN HOMEROW.BIN
TILEMAPS		= GAMEMAP.BIN \
				  TITLEMAP.BIN

all: clean $(PROG)

tilemaps: $(TILEMAPS)

$(PROG): $(SOURCES)
	$(ASSEMBLER6502) $(ASFLAGS) -o $(PROG) $(MAIN)

GAMEMAP.BIN: tile_map.tmx
	tmx2vera tile_map.tmx GAMEMAP.BIN -l main

TITLEMAP.BIN: title.tmx
	tmx2vera title.tmx TITLEMAP.BIN -l main

words: $(WORD_FILES)

ANI0.BIN:
	$(ACME) $(ACME_FLAGS) --outfile ANI0.BIN animals0.asm

HOMEROW.BIN:
	$(ACME) $(ASSEMBLER6502) --outfile HOMEROW.BIN homerow.asm

run: all tilemaps words
	x16emu -prg $(PROG) -run -scale 2 -debug

clean:
	rm -f $(PROG) $(LIST)
	
clean_tilemaps:
	rm  -f $(TILEMAPS)

cleanall: clean clean_tilemaps
