SHELL    := /bin/bash

EXEC     := rhovec

BUILDDIR := _build/default
TESTDIR  := $(BUILDDIR)/test
SRCDIR   := $(BUILDDIR)/src

all: exe

run: exe
	./$(EXEC)

test: test-parse test-eval

test-parse:
	dune build test/parse.exe
	cd $(TESTDIR) && ./parse.exe --compact

test-eval:
	dune build test/eval.exe
	cd $(TESTDIR) && ./eval.exe --compact

test-oracle:
	dune build test/eval.exe
	cd $(TESTDIR) && DUMP=suite.R ./eval.exe test --compact "dummy"
	R -f $(TESTDIR)/suite.R

utop:
	dune utop lib

debug: bc
	ocamldebug $(SRCDIR)/main.bc

exe:
	dune build src/main.exe
	cp $(SRCDIR)/main.exe $(EXEC)
	@chmod 755 $(EXEC)

bc:
	dune build src/main.bc

fmt:
	@# force this command to always return true
	dune build @fmt --auto-promote || true

coverage: clean
	BISECT_ENABLE=yes dune build
	dune runtest --force
	bisect-ppx-report html
	bisect-ppx-report summary

deps:
	opam install . --deps-only --with-test

clean:
	dune clean
	rm -rf _coverage
	rm -f $(EXEC)

.PHONY: all run test test-parse test-eval testoracle utop debug exe bc fmt coverage deps clean
