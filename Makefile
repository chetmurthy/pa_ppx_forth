# Makefile,v
# Copyright (c) INRIA 2007-2017

WD=$(shell pwd)
TOP=.
include $(TOP)/config/Makefile

DESTDIR=
RM=rm

LAUNCH=
OCAMLFIND=$(LAUNCH) ocamlfind
NOT_OCAMLFIND=$(LAUNCH) not-ocamlfind
MKCAMLP5=$(LAUNCH) mkcamlp5
SYNTAX := camlp5o

PACKAGES := $(PACKAGES),fmt,pa_ppx.base
TARGET := pa_ppx_forth.cma
ML := pa_forth.ml
CMO := $(ML:.ml=.cmo)
CMI := $(ML:.ml=.cmi)
CMX := $(ML:.ml=.cmx)
CMT := $(ML:.ml=.cmt)
CMTI := $(MLI:.mli=.cmti)

all: $(TARGET) $(TARGET:.cma=.cmxa) camlp5.pa_ppx_forth camlp5.pa_ppx_forth.opt
	$(MAKE) DESTDIR=$(WD)/$(TOP)/local-install/ install

test:: all
	make -C test clean all-tests

doc: $(CMT) $(CMTI)

camlp5.pa_ppx_forth: $(TARGET)
	$(MKCAMLP5) -verbose -package fmt,camlp5.pa_r,camlp5.pr_r,pa_ppx.base $(TARGET) -o $@

camlp5.pa_ppx_forth.opt: $(TARGET:.cma=.cmxa)
	$(MKCAMLP5).opt -verbose -package fmt,camlp5.pa_r,camlp5.pr_r,pa_ppx.base $(TARGET:.cma=.cmxa) -o $@

META: META.pl
	./META.pl > META

install::
	mkdir -p $(DESTDIR)/lib
	./META.pl $(DESTDIR)/lib > META
	$(NOT_OCAMLFIND) reinstall-if-diff pa_ppx_forth -destdir $(DESTDIR)/lib META $(TARGET) $(TARGET:.cma=.cmxa) $(TARGET:.cma=.a) $(wildcard *.cmt*)
	$(RM) -f META

clean::
	rm -rf META camlp5.pa_ppx_forth* local-install
	make -C test clean

$(TARGET): $(CMO)
	$(OCAMLFIND) ocamlc $(DEBUG) $(CMO) -a -o $(TARGET)

$(TARGET:.cma=.cmxa): $(CMO:.cmo=.cmx)
	$(OCAMLFIND) ocamlopt $(DEBUG) $(CMO:.cmo=.cmx) -a -o $(TARGET:.cma=.cmxa)

$(TARGET): $(CMO)
$(TARGET:.cma=.cmxa): $(CMO:.cmo=.cmx)

EXTERNAL := $(shell $(OCAMLFIND) query -predicates byte -format '%m' $(PACKAGES) | grep local-install)
$(CMO) $(CMI) $(CMX): $(EXTERNAL)

depend::
	echo "$(CMO) $(CMI) $(CMX): $(EXTERNAL)" > .depend.NEW
	$(OCAMLFIND) ocamldep $(DEBUG) -package $(PACKAGES) -syntax camlp5o *.ml *.mli >> .depend.NEW \
		&& mv .depend.NEW .depend

-include .depend
