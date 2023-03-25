NAME = TYPE
TITLE = X16-Typing-Tutor
VERSION = 0.0.1
ASSEMBLER6502 = cl65
ASFLAGS = -t cx16 -l $(NAME).list

PROG = $(NAME).PRG
LIST = $(NAME).list
MAIN = main.asm
SOURCES = $(MAIN) \
		  x16.inc \
		  vera.inc

ZIPFILE = $(TITLE)_$(VERSION).zip

WORD_FILES		= ANI0.BIN HOMEROW.BIN QUICKFOX.BIN
TILEMAPS		= GAMEMAP.BIN \
				  TITLEMAP.BIN

all: clean $(PROG)

tilemaps: $(TILEMAPS)

$(PROG): $(SOURCES)
	$(ASSEMBLER6502) $(ASFLAGS) -o $(PROG) $(MAIN)

GAMEMAP.BIN: tile_map.tmx
	tmx2vera tile_map.tmx GAMEMAP.BIN -l main -d

TITLEMAP.BIN: title.tmx
	tmx2vera title.tmx TITLEMAP.BIN -l main -d

words: $(WORD_FILES)

ANI0.BIN: animals0.asm
	$(ASSEMBLER6502) $(ASFLAGS) -o temp.bin animals0.asm -l ANI0.list
	# cheap hack because I can't figure out how to remove a header from cl65 output
	tail -c +13 temp.bin > ANI0.BIN
	rm temp.bin

QUICKFOX.BIN: quickfox.asm
	$(ASSEMBLER6502) $(ASFLAGS) -o temp.bin quickfox.asm -l QUICKFOX.list
	# cheap hack because I can't figure out how to remove a header from cl65 output
	tail -c +13 temp.bin > QUICKFOX.BIN
	rm temp.bin

HOMEROW.BIN: homerow.asm
	$(ASSEMBLER6502) $(ASFLAGS) -o temp.bin homerow.asm -l HOMEROW.list
	# cheap hack because I can't figure out how to remove a header from cl65 output
	tail -c +13 temp.bin > HOMEROW.BIN
	rm temp.bin

run: all tilemaps words
	x16emu -prg $(PROG) -run -scale 2 -debug

$(ZIPFILE): all tilemaps words clean_zip
	zip $(ZIPFILE) *.PRG *.BIN

zip: $(ZIPFILE)


clean:
	rm -f $(PROG) $(LIST)
	
clean_zip:
	rm -f $(ZIPFILE)

clean_tilemaps:
	rm  -f $(TILEMAPS)

clean_wordfiles:
	rm -f $(WORD_FILES)

cleanall: clean clean_tilemaps clean_wordfiles clean_zip
