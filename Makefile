ASSEMBLER6502	= acme
AS_FLAGS		= -f cbm -DMACHINE_C64=0
RM				= rm

PROGS			= type.prg balloons.prg

all: $(PROGS)

type.prg:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile type.prg type.asm

balloons.prg:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile balloons.prg balloons.asm

balloons: clean balloons.prg
	./x16emu -prg balloons.prg -run -scale 2

run: clean type.prg
	./x16emu -prg type.prg -run -scale 2

clean:
	-$(RM) -f *.o *.tmp $(PROGS) *~ core
