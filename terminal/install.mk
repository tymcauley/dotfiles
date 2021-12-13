.PHONY: terminal
ALL_TARGETS += terminal

terminal:
	./install_file.sh terminal/alacritty.yml ~/.config/alacritty/alacritty.yml
	./install_file.sh terminal/kitty.conf    ~/.config/kitty/kitty.conf
	./git_clone_or_pull.sh https://gitlab.com/protesilaos/tempus-themes-kitty.git ~/.config/kitty/tempus-themes-kitty
