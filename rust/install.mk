.PHONY: rust
ALL_TARGETS  += rust
TOOL_TARGETS += rust

rust_TOOL := rustup
rust_HINT := https://rustup.rs

rust: ## Update rustup, install rust-analyzer
	@$(call check-tool,$(rust_TOOL),$(rust_HINT))
	rustup update
	rustup component add rust-analyzer
