ASSEMBLER6502	= acme
AS_FLAGS		= -f cbm -DMACHINE_C64=0 -Wtype-mismatch --cpu w65c02
RM				= rm

PROGS			= type.prg

all: $(PROGS)

type.prg:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile type.prg main.asm

run: clean type.prg
	./x16emu -prg type.prg -run -scale 2 -debug

clean:
	$(RM) -f *.o *.tmp $(PROGS) *~ core

video:
	./x16emu -bas utils/video_settings.bas -run -scale 2 -debug
