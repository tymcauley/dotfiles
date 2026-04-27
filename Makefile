ifeq ($(wildcard cfg.mk),)
$(error Missing dotfiles config file 'cfg.mk', run './init.sh' to generate one)
endif

include cfg.mk
include common.mk

ALL_TARGETS  =
TOOL_TARGETS =

.PHONY: all default help doctor
default: all

MODULES := $(patsubst %/install.mk,%,$(wildcard */install.mk))
upper    = $(shell echo $1 | tr '[:lower:]' '[:upper:]')

$(foreach m,$(MODULES),\
	$(if $(filter 1,$($(call upper,$m))),\
		$(eval include $m/install.mk)))

all: $(ALL_TARGETS) ## Install all enabled modules

help: ## Show this help message
	@echo "Enabled modules: $(ALL_TARGETS)"
	@echo
	@echo "Targets:"
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z0-9_-]+:.*## / { printf "  %-15s %s\n", $$1, $$2 }' Makefile $(wildcard */install.mk)

doctor: ## Report missing tools required by enabled modules
	@status=0; \
	$(foreach t,$(TOOL_TARGETS),$($(t)_CHECK) >/dev/null 2>&1 || { echo "$(t) needs '$($(t)_TOOL)': $($(t)_HINT)"; status=1; }; ) \
	[ $$status -eq 0 ] && echo "all required tools installed"; \
	exit $$status
