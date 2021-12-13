.PHONY: haskell
ALL_TARGETS += haskell

ifeq ($(shell which ghcup 2> /dev/null),)
$(error Please install ghcup: >>> \
	curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh \
	<<<)
endif

GHCUP_INSTALLED_TOOLS = $(shell ghcup list --show-criteria installed --raw-format 2> /dev/null | cut -f 1 -d " " | uniq)
GHCUP_TOOLS_TO_INSTALL = $(filter-out $(GHCUP_INSTALLED_TOOLS),$(GHCUP_TOOLS))

haskell:
	ghcup upgrade
	@for tool in $(GHCUP_TOOLS_TO_INSTALL) ; do \
		ghcup install $$tool ; \
	done
