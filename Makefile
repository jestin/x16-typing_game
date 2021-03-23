ASSEMBLER6502	= acme
AS_FLAGS		= -f cbm -DMACHINE_C64=0 -Wtype-mismatch --cpu w65c02
RM				= rm

PROGS			= TYPE.PRG STR.BIN

all: $(PROGS)

STR.BIN:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile STR.BIN str.asm

TYPE.PRG: STR.BIN
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile TYPE.PRG main.asm

run: clean TYPE.PRG
	./x16emu -prg TYPE.PRG -run -scale 2 -debug

clean:
	$(RM) -f *.o *.tmp $(PROGS) *~ core

video:
	./x16emu -bas utils/video_settings.bas -run -scale 2 -debug
