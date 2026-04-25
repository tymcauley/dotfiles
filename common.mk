OS   := $(shell uname -s)
ARCH := $(shell uname -m)

# $(call check-tool,name,hint) — recipe step that fails if 'name' isn't on PATH.
check-tool = command -v $(1) >/dev/null 2>&1 || { echo "missing '$(1)': $(2)" >&2; exit 1; }
