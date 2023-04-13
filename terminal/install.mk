.PHONY: terminal
ALL_TARGETS += terminal

terminal:
	./install_file.sh terminal/alacritty.yml         ~/.config/alacritty/alacritty.yml
	./install_file.sh terminal/kitty.conf            ~/.config/kitty/kitty.conf
	./install_file.sh terminal/wezterm.lua           ~/.config/wezterm/wezterm.lua
	./install_file.sh terminal/tokyonight_storm.conf ~/.config/kitty/tokyonight_storm.conf
	./install_file.sh terminal/tokyonight_storm.toml ~/.config/wezterm/colors/tokyonight_storm.toml
