.PHONY: tmux
ALL_TARGETS += tmux

tmux:
	./install_file.sh tmux/tmux.conf   ~/.tmux.conf
	./install_file.sh tmux/status.conf ~/.tmux/status.conf
	./install_file.sh tmux/yank.sh     ~/.tmux/yank.sh
	./git_clone_or_pull.sh https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
