.PHONY: git
ALL_TARGETS += git

git:
	./install_file.sh git/gitconfig                  ~/.gitconfig
	./install_file.sh git/gitignore_global           ~/.config/git/gitignore_global
	./install_file.sh git/tokyonight_storm.gitconfig ~/.config/git/tokyonight_storm.gitconfig
