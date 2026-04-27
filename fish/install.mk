.PHONY: fish
ALL_TARGETS  += fish
TOOL_TARGETS += fish

fish_TOOL  := fisher
fish_HINT  := https://github.com/jorgebucaran/fisher
fish_CHECK := fish -c 'functions -q fisher'

FISH_CONFIG_DIR := ~/.config/fish

fish: ## Install fish shell config and plugins
	@$(call check-tool,$(fish_TOOL),$(fish_HINT),$(fish_CHECK))
	./install_file.sh fish/config.fish  $(FISH_CONFIG_DIR)/config.fish
	./install_file.sh fish/aliases.fish $(FISH_CONFIG_DIR)/aliases.fish
	./install_file.sh fish/ssh.fish     $(FISH_CONFIG_DIR)/ssh.fish
	./install_file.sh fish/fish_plugins $(FISH_CONFIG_DIR)/fish_plugins
	fish -c 'fisher update'
