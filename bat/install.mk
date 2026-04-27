.PHONY: bat
ALL_TARGETS  += bat
TOOL_TARGETS += bat

bat_TOOL  := bat
bat_HINT  := https://github.com/sharkdp/bat
bat_CHECK := command -v $(bat_TOOL)

BAT_THEMES_DIR = $(shell bat --config-dir)/themes

bat: ## Install bat theme
	@$(call check-tool,$(bat_TOOL),$(bat_HINT),$(bat_CHECK))
	./install_file.sh bat/tokyonight_storm.tmTheme $(BAT_THEMES_DIR)/tokyonight_storm.tmTheme
	bat cache --build
