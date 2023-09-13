.PHONY: zsh
ALL_TARGETS += zsh

ZSH_DIR := ~/.zsh

zsh:
	mkdir -p $(ZSH_DIR)/completions $(ZSH_DIR)/plugins
	./install_file.sh zsh/p10k.zsh       ~/.p10k.zsh
	./install_file.sh zsh/zshrc          ~/.zshrc
	./install_file.sh zsh/git.zsh        ~/.config/git.zsh
	./install_file.sh zsh/editor.zsh     ~/.config/editor.zsh
	./install_file.sh zsh/fzf-config.zsh ~/.config/fzf-config.zsh
	./git_clone_or_pull.sh https://github.com/romkatv/powerlevel10k.git $(ZSH_DIR)/plugins/powerlevel10k
