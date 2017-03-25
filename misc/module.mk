MISC_SRC_LIB := 
MISC_SRC := $(MISC_SRC_LIB) containeroftest.c murmurtest.c

MISC_SRC_LIB := $(patsubst %,$(DIRMISC)/%,$(MISC_SRC_LIB))
MISC_SRC := $(patsubst %,$(DIRMISC)/%,$(MISC_SRC))

MISC_OBJ_LIB := $(patsubst %.c,%.o,$(MISC_SRC_LIB))
MISC_OBJ := $(patsubst %.c,%.o,$(MISC_SRC))

MISC_DEP_LIB := $(patsubst %.c,%.d,$(MISC_SRC_LIB))
MISC_DEP := $(patsubst %.c,%.d,$(MISC_SRC))

CFLAGS_MISC :=

MAKEFILES_MISC := $(DIRMISC)/module.mk

.PHONY: MISC clean_MISC distclean_MISC unit_MISC $(LCMISC) clean_$(LCMISC) distclean_$(LCMISC) unit_$(LCMISC)

$(LCMISC): MISC
clean_$(LCMISC): clean_MISC
distclean_$(LCMISC): distclean_MISC

MISC: $(DIRMISC)/libmisc.a $(DIRMISC)/containeroftest $(DIRMISC)/murmurtest

unit_MISC: $(DIRMISC)/containeroftest $(DIRMISC)/murmurtest
	$(DIRMISC)/containeroftest
	$(DIRMISC)/murmurtest

$(DIRMISC)/libmisc.a: $(MISC_OBJ_LIB) $(MAKEFILES_COMMON) $(MAKEFILES_MISC)
	rm -f $@
	ar rvs $@ $(filter %.o,$^)

$(DIRMISC)/containeroftest: $(DIRMISC)/containeroftest.o $(DIRMISC)/libmisc.a $(MAKEFILES_COMMON) $(MAKEFILES_MISC)
	$(CC) $(CFLAGS) -o $@ $(filter %.o,$^) $(filter %.a,$^) $(CFLAGS_MISC)

$(DIRMISC)/murmurtest: $(DIRMISC)/murmurtest.o $(DIRMISC)/libmisc.a $(MAKEFILES_COMMON) $(MAKEFILES_MISC)
	$(CC) $(CFLAGS) -o $@ $(filter %.o,$^) $(filter %.a,$^) $(CFLAGS_MISC)

$(MISC_OBJ): %.o: %.c $(MISC_DEP) $(MAKEFILES_COMMON) $(MAKEFILES_MISC)
	$(CC) $(CFLAGS) -c -o $*.o $*.c $(CFLAGS_MISC)

$(MISC_DEP): %.d: %.c $(MAKEFILES_COMMON) $(MAKEFILES_MISC)
	$(CC) $(CFLAGS) -MM -MP -MT "$*.d $*.o" -o $*.d $*.c $(CFLAGS_MISC)

clean_MISC:
	rm -f $(MISC_OBJ) $(MISC_DEP)

distclean_MISC: clean_MISC
	rm -f $(DIRMISC)/libmisc.a $(DIRMISC)/containeroftest

-include $(MISC_DEP)