.PHONY: bat
ALL_TARGETS += bat

ifeq ($(shell which bat 2> /dev/null),)
$(error Please install bat: https://github.com/sharkdp/bat)
endif

BAT_THEMES_DIR := $(shell bat --config-dir)/themes

bat:
	./install_file.sh bat/tokyonight_storm.tmTheme $(BAT_THEMES_DIR)/tokyonight_storm.tmTheme
	bat cache --build
