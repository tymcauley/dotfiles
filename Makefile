ifeq ($(wildcard cfg.mk),)
$(error Missing dotfiles config file 'cfg.mk', check examples in 'config/' folder)
endif

include cfg.mk

ALL_TARGETS =

.PHONY: all default
default: all

ifeq ($(BAT),1)
include bat/install.mk
endif

ifeq ($(BREW),1)
include brew/install.mk
endif

ifeq ($(FISH),1)
include fish/install.mk
endif

ifeq ($(GIT),1)
include git/install.mk
endif

ifeq ($(HASKELL),1)
include haskell/install.mk
endif

ifeq ($(NODE),1)
include node/install.mk
endif

ifeq ($(NVIM),1)
include nvim/install.mk
endif

ifeq ($(PYTHON),1)
include python/install.mk
endif

ifeq ($(RUST),1)
include rust/install.mk
endif

ifeq ($(SCALA),1)
include scala/install.mk
endif

ifeq ($(TERMINAL),1)
include terminal/install.mk
endif

ifeq ($(TMUX),1)
include tmux/install.mk
endif

ifeq ($(ZELLIJ),1)
include zellij/install.mk
endif

ifeq ($(ZSH),1)
include zsh/install.mk
endif

all: $(ALL_TARGETS)
