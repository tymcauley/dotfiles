OS   := $(shell uname -s)
ARCH := $(shell uname -m)

# $(call check-tool,name,hint,check-cmd) — recipe step that fails if check-cmd
# returns nonzero. For binaries on PATH, pass 'command -v <name>'.
check-tool = $(3) >/dev/null 2>&1 || { echo "missing '$(1)': $(2)" >&2; exit 1; }
