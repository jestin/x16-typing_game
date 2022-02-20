ASSEMBLER6502	= acme
AS_FLAGS		= -f cbm -DMACHINE_C64=0 -Wtype-mismatch --cpu w65c02
RM				= rm

PROGS			= TYPE.PRG
WORD_FILES		= ANI0.BIN HOMEROW.BIN
TILEMAPS		= GAMEMAP.BIN \
				  TITLEMAP.BIN

all: $(PROGS)

tilemaps: $(TILEMAPS)

ANI0.BIN:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile ANI0.BIN animals0.asm

HOMEROW.BIN:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile HOMEROW.BIN homerow.asm


GAMEMAP.BIN: tile_map.tmx
	tmx2vera tile_map.tmx GAMEMAP.BIN -l main

TITLEMAP.BIN: title.tmx
	tmx2vera title.tmx TITLEMAP.BIN -l main

WORDS: $(WORD_FILES)


TYPE.PRG: WORDS
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile TYPE.PRG main.asm

run: clean TYPE.PRG tilemaps
	x16emu -prg TYPE.PRG -run -scale 2 -debug

clean:
	$(RM) -f *.o *.tmp $(PROGS) $(WORD_FILES) *~ core

clean_tilemaps:
	rm  -f $(TILEMAPS)

cleanall: clean clean_tilemaps

video:
	x16emu -bas utils/video_settings.bas -run -scale 2 -debug
