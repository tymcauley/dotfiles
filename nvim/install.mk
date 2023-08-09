.PHONY: nvim
ALL_TARGETS += nvim

nvim:
	./install_file.sh nvim/init.lua       ~/.config/nvim/init.lua
	./install_dir.sh  nvim/lua            ~/.config/nvim/lua
	./install_dir.sh  nvim/lua/plugins    ~/.config/nvim/lua/plugins
	./install_dir.sh  nvim/after/ftplugin ~/.config/nvim/after/ftplugin
