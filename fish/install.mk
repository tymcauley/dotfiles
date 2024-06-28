.PHONY: fish
ALL_TARGETS += fish

FISH_CONFIG_DIR := ~/.config/fish

fish:
	./install_file.sh fish/config.fish  $(FISH_CONFIG_DIR)/config.fish
	./install_file.sh fish/aliases.fish $(FISH_CONFIG_DIR)/aliases.fish
	./install_file.sh fish/fish_plugins $(FISH_CONFIG_DIR)/fish_plugins
