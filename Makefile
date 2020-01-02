ASSEMBLER6502	= acme
AS_FLAGS		= -f cbm -DMACHINE_C64=0 -Wtype-mismatch
RM				= rm

PROGS			= type.prg

all: $(PROGS)

type.prg:
	$(ASSEMBLER6502) $(AS_FLAGS) --outfile type.prg type.asm

run: clean type.prg
	./x16emu -prg type.prg -run -scale 2

clean:
	-$(RM) -f *.o *.tmp $(PROGS) *~ core
