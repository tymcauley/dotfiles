.PHONY: rust
ALL_TARGETS  += rust
TOOL_TARGETS += rust

rust_TOOL  := rustup
rust_HINT  := https://rustup.rs
rust_CHECK := command -v $(rust_TOOL)

rust: ## Update rustup, install rust-analyzer
	@$(call check-tool,$(rust_TOOL),$(rust_HINT),$(rust_CHECK))
	rustup update
	rustup component add rust-analyzer
