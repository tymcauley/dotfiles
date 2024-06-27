.PHONY: zsh
ALL_TARGETS += zsh

ZDOTDIR := ~/.config/zsh

zsh:
	mkdir -p $(ZDOTDIR)/completions $(ZDOTDIR)/plugins
	./install_file.sh zsh/zshenv         ~/.zshenv
	./install_file.sh zsh/p10k.zsh       $(ZDOTDIR)/.p10k.zsh
	./install_file.sh zsh/zshrc          $(ZDOTDIR)/.zshrc
	./install_file.sh zsh/aliases.zsh    $(ZDOTDIR)/aliases.zsh
	./install_file.sh zsh/completion.zsh $(ZDOTDIR)/completion.zsh
	./install_file.sh zsh/editor.zsh     $(ZDOTDIR)/editor.zsh
	./git_clone_or_pull.sh https://github.com/romkatv/powerlevel10k.git $(ZDOTDIR)/plugins/powerlevel10k
