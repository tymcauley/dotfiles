.PHONY: terminal
ALL_TARGETS += terminal

terminal:
	./install_file.sh terminal/alacritty.yml               ~/.config/alacritty/alacritty.yml
	./install_file.sh terminal/kitty.conf                  ~/.config/kitty/kitty.conf
	./install_file.sh terminal/kitty_tokyonight_storm.conf ~/.config/kitty/kitty_tokyonight_storm.conf
