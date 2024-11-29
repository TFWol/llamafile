#-*-mode:makefile-gmake;indent-tabs-mode:t;tab-width:8;coding:utf-8-*-┐
#── vi: set noet ft=make ts=8 sw=8 fenc=utf-8 :vi ────────────────────┘

SHELL = /bin/sh
MAKEFLAGS += --no-builtin-rules

.SUFFIXES:
.DELETE_ON_ERROR:
.FEATURES: output-sync

include build/config.mk
include build/rules.mk

# Keep only necessary includes
include llamafile/BUILD.mk
include llama.cpp/BUILD.mk

# Modify main target to build only llamafile-related components
.PHONY: o/$(MODE)/
o/$(MODE)/:	o/$(MODE)/llamafile					\
        o/$(MODE)/llama.cpp

# Adjust install target for llamafile-related binaries and man pages
.PHONY: install
install:	llamafile/zipalign.1					\
        llamafile/server/main.1					\
        llama.cpp/main/main.1					\
        llama.cpp/imatrix/imatrix.1				\
        llama.cpp/quantize/quantize.1				\
        llama.cpp/perplexity/perplexity.1			\
        llama.cpp/llava/llava-quantize.1			\
        o/$(MODE)/llamafile/zipalign				\
        o/$(MODE)/llamafile/tokenize				\
        o/$(MODE)/llama.cpp/main/main				\
        o/$(MODE)/llama.cpp/imatrix/imatrix			\
        o/$(MODE)/llama.cpp/quantize/quantize			\
        o/$(MODE)/llama.cpp/llama-bench/llama-bench		\
        o/$(MODE)/llama.cpp/perplexity/perplexity		\
        o/$(MODE)/llama.cpp/llava/llava-quantize		\
        o/$(MODE)/llamafile/server/main
    mkdir -p $(PREFIX)/bin
    $(INSTALL) o/$(MODE)/llamafile/zipalign $(PREFIX)/bin/zipalign
    $(INSTALL) o/$(MODE)/llamafile/tokenize $(PREFIX)/bin/llamafile-tokenize
    $(INSTALL) o/$(MODE)/llama.cpp/main/main $(PREFIX)/bin/llamafile
    $(INSTALL) o/$(MODE)/llama.cpp/imatrix/imatrix $(PREFIX)/bin/llamafile-imatrix
    $(INSTALL) o/$(MODE)/llama.cpp/quantize/quantize $(PREFIX)/bin/llamafile-quantize
    $(INSTALL) o/$(MODE)/llama.cpp/llama-bench/llama-bench $(PREFIX)/bin/llamafile-bench
    $(INSTALL) build/llamafile-convert $(PREFIX)/bin/llamafile-convert
    $(INSTALL) build/llamafile-upgrade-engine $(PREFIX)/bin/llamafile-upgrade-engine
    $(INSTALL) o/$(MODE)/llama.cpp/perplexity/perplexity $(PREFIX)/bin/llamafile-perplexity
    $(INSTALL) o/$(MODE)/llama.cpp/llava/llava-quantize $(PREFIX)/bin/llava-quantize
    $(INSTALL) o/$(MODE)/llamafile/server/main $(PREFIX)/bin/llamafiler
    mkdir -p $(PREFIX)/share/man/man1
    $(INSTALL) -m 0644 llamafile/zipalign.1 $(PREFIX)/share/man/man1/zipalign.1
    $(INSTALL) -m 0644 llamafile/server/main.1 $(PREFIX)/share/man/man1/llamafiler.1
    $(INSTALL) -m 0644 llama.cpp/main/main.1 $(PREFIX)/share/man/man1/llamafile.1
    $(INSTALL) -m 0644 llama.cpp/imatrix/imatrix.1 $(PREFIX)/share/man/man1/llamafile-imatrix.1
    $(INSTALL) -m 0644 llama.cpp/quantize/quantize.1 $(PREFIX)/share/man/man1/llamafile-quantize.1
    $(INSTALL) -m 0644 llama.cpp/perplexity/perplexity.1 $(PREFIX)/share/man/man1/llamafile-perplexity.1
    $(INSTALL) -m 0644 llama.cpp/llava/llava-quantize.1 $(PREFIX)/share/man/man1/llava-quantize.1

.PHONY: check
check: o/$(MODE)/llamafile/check

.PHONY: cosmocc
cosmocc: $(COSMOCC) # cosmocc toolchain setup

.PHONY: cosmocc-ci
cosmocc-ci: $(COSMOCC) $(PREFIX)/bin/ape # cosmocc toolchain setup in ci context

include build/deps.mk
include build/tags.mk
