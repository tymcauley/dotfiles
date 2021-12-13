.PHONY: zsh
ALL_TARGETS += zsh

OMZ_DIR := ~/.oh-my-zsh

ifeq ($(wildcard $(OMZ_DIR)/.),)
$(error Please install oh-my-zsh: >>> \
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
	<<<)
endif

zsh:
	mkdir -p $(OMZ_DIR)/completions
	./install_file.sh zsh/p10k.zsh       ~/.p10k.zsh
	./install_file.sh zsh/zshrc          ~/.zshrc
	./install_file.sh zsh/git.zsh        ~/.config/git.zsh
	./install_file.sh zsh/editor.zsh     ~/.config/editor.zsh
	./install_file.sh zsh/fzf-config.zsh ~/.config/fzf-config.zsh
	./git_clone_or_pull.sh https://github.com/romkatv/powerlevel10k.git $(OMZ_DIR)/custom/themes/powerlevel10k
	./git_clone_or_pull.sh https://github.com/jeffreytse/zsh-vi-mode    $(OMZ_DIR)/custom/plugins/zsh-vi-mode
