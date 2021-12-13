.PHONY: rust
ALL_TARGETS += rust

ifeq ($(shell which rustup 2> /dev/null),)
$(error Please install rustup: >>> \
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y \
	<<<)
endif

ifeq ($(shell uname),Darwin)
RUST_ANALYZER_NAME := rust-analyzer-x86_64-apple-darwin
else
RUST_ANALYZER_NAME := rust-analyzer-x86_64-unknown-linux-gnu
endif
RUST_ANALYZER_URL := https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/$(RUST_ANALYZER_NAME).gz

# TODO: Install zsh completions for rustup?
# TODO: `cargo install cargo-edit`?

rust:
	rustup update
	curl -L $(RUST_ANALYZER_URL) | gunzip -c - > ~/.local/bin/rust-analyzer
	chmod +x ~/.local/bin/rust-analyzer
