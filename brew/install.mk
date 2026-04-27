.PHONY: brew
ALL_TARGETS  += brew
TOOL_TARGETS += brew

brew_TOOL  := brew
brew_HINT  := https://brew.sh
brew_CHECK := command -v $(brew_TOOL)

BREW_INSTALLED_FORMULAE  = $(shell brew list --formula -1)
BREW_FORMULAE_TO_INSTALL = $(filter-out $(BREW_INSTALLED_FORMULAE),$(BREW_FORMULAE))

# Casks are only supported on macOS, not Linux
ifeq ($(OS),Darwin)
BREW_INSTALLED_CASKS  = $(shell brew list --cask -1)
BREW_CASKS_TO_INSTALL = $(filter-out $(BREW_INSTALLED_CASKS),$(BREW_CASKS))
endif

brew: ## Install/upgrade configured brew formulae and casks
	@$(call check-tool,$(brew_TOOL),$(brew_HINT),$(brew_CHECK))
	brew update
	brew upgrade --greedy
	@for formula in $(BREW_FORMULAE_TO_INSTALL) ; do \
		brew install $$formula ; \
	done
ifeq ($(OS),Darwin)
	@for cask in $(BREW_CASKS_TO_INSTALL) ; do \
		brew install $$cask ; \
	done
endif
