.PHONY: brew
ALL_TARGETS += brew

ifeq ($(shell which brew 2> /dev/null),)
$(error Please install homebrew: >>> \
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
	<<<)
endif

BREW_INSTALLED_FORMULAE  = $(shell brew list --formula -1)
BREW_FORMULAE_TO_INSTALL = $(filter-out $(BREW_INSTALLED_FORMULAE),$(BREW_FORMULAE))

# Casks are only supported on macOS, not Linux
ifeq ($(shell uname),Darwin)
BREW_INSTALLED_CASKS  = $(shell brew list --cask -1)
BREW_CASKS_TO_INSTALL = $(filter-out $(BREW_INSTALLED_CASKS),$(BREW_CASKS))
endif

brew:
	brew update
	brew upgrade --greedy
	@for formula in $(BREW_FORMULAE_TO_INSTALL) ; do \
		brew install $$formula ; \
	done
ifeq ($(shell uname),Darwin)
	@for cask in $(BREW_CASKS_TO_INSTALL) ; do \
		brew install $$cask ; \
	done
endif
