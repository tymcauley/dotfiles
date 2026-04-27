.PHONY: haskell
ALL_TARGETS  += haskell
TOOL_TARGETS += haskell

haskell_TOOL  := ghcup
haskell_HINT  := https://www.haskell.org/ghcup/
haskell_CHECK := command -v $(haskell_TOOL)

GHCUP_INSTALLED_TOOLS = $(shell ghcup list --show-criteria installed --raw-format 2> /dev/null | cut -f 1 -d " " | uniq)
GHCUP_TOOLS_TO_INSTALL = $(filter-out $(GHCUP_INSTALLED_TOOLS),$(GHCUP_TOOLS))

haskell: ## Install configured ghcup tools
	@$(call check-tool,$(haskell_TOOL),$(haskell_HINT),$(haskell_CHECK))
	ghcup upgrade
	@for tool in $(GHCUP_TOOLS_TO_INSTALL) ; do \
		ghcup install $$tool ; \
	done
