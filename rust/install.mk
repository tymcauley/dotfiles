.PHONY: rust
ALL_TARGETS  += rust
TOOL_TARGETS += rust

rust_TOOL := rustup
rust_HINT := https://rustup.rs

ifeq ($(OS),Darwin)
ifeq ($(ARCH),arm64)
RUST_ANALYZER_NAME := rust-analyzer-aarch64-apple-darwin
else
RUST_ANALYZER_NAME := rust-analyzer-x86_64-apple-darwin
endif
else
RUST_ANALYZER_NAME := rust-analyzer-x86_64-unknown-linux-gnu
endif
RUST_ANALYZER_URL := https://github.com/rust-lang/rust-analyzer/releases/latest/download/$(RUST_ANALYZER_NAME).gz

# TODO: Install zsh completions for rustup?

rust: ## Update rustup, install rust-analyzer
	@$(call check-tool,$(rust_TOOL),$(rust_HINT))
	rustup update
	curl -L $(RUST_ANALYZER_URL) | gunzip -c - > ~/.local/bin/rust-analyzer
	chmod +x ~/.local/bin/rust-analyzer
