WD=$(shell pwd)
TOP=..
include $(TOP)/config/Makefile

LAUNCH=../tools/LAUNCH
OCAMLFIND=$(LAUNCH) ocamlfind
NOT_OCAMLFIND=$(LAUNCH) not-ocamlfind
SYNTAX := camlp5o

PACKAGES := $(PACKAGES),pa_ppx_forth,oUnit

all: ppx_forth.exe

all-tests:: all
	./ppx_forth.exe

ppx_forth.exe: ppx_forth.cmo
	$(OCAMLFIND) ocamlc $(OCAMLCFLAGS) -package $(PACKAGES) -linkpkg -linkall -o $@ $<

clean::
	rm -f *.cm* *.exe
