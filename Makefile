ASSEMBLER6502	= acme
AS_FLAGS		= -f cbm -DMACHINE_C64=0 -Wtype-mismatch --cpu w65c02
RM				= rm

PROGS			= TYPE.PRG
WORD_FILES		= ANI0.BIN HOMEROW.BIN
TILE_FILES		= TILES.BIN TITLEMAP.BIN

all: $(PROGS)

ANI0.BIN:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile ANI0.BIN animals0.asm

HOMEROW.BIN:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile HOMEROW.BIN homerow.asm

TILES.BIN:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile TILES.BIN tiles.asm

GAMEMAP.BIN:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile GAMEMAP.BIN game_map.asm

TITLEMAP.BIN:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile TITLEMAP.BIN title_map.asm

WORDS: $(WORD_FILES)

TILES: $(TILE_FILES)

TYPE.PRG: WORDS TILES
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile TYPE.PRG main.asm

run: clean TYPE.PRG
	./x16emu -prg TYPE.PRG -run -scale 2 -debug

clean:
	$(RM) -f *.o *.tmp $(PROGS) $(WORD_FILES) $(TILE_FILES) *~ core

video:
	./x16emu -bas utils/video_settings.bas -run -scale 2 -debug
