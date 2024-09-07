.PHONY: nvim update-nvim
ALL_TARGETS += nvim

nvim:
	./install_file.sh nvim/init.lua       ~/.config/nvim/init.lua
	./install_dir.sh  nvim/lua            ~/.config/nvim/lua
	./install_dir.sh  nvim/lua/plugins    ~/.config/nvim/lua/plugins
	./install_dir.sh  nvim/after/ftplugin ~/.config/nvim/after/ftplugin

# If this is 1 on Linux, then download a version which works with older glibc.
OLD_GLIBC ?= 0
ifeq ($(shell uname),Darwin)
NVIM_REPO := neovim
else ifeq ($(OLD_GLIBC),0)
NVIM_REPO := neovim
else
NVIM_REPO := neovim-releases
endif
NVIM_URL := https://github.com/neovim/$(NVIM_REPO)/releases/download/nightly

# Update to latest nightly build of neovim for macOS/Linux
update-nvim:
ifeq ($(shell uname),Darwin)
	curl -fLO $(NVIM_URL)/nvim-macos-arm64.tar.gz && \
		xattr -c ./nvim-macos-arm64.tar.gz && \
		tar xzf nvim-macos-arm64.tar.gz && \
		rm -rf ~/.local/nvim-macos-arm64 && \
		mv nvim-macos-arm64 ~/.local/ && \
		rm ./nvim-macos-arm64.tar.gz
else
	curl -fLO $(NVIM_URL)/nvim.appimage && \
		mv nvim.appimage ~/.local/bin && \
		cd ~/.local/bin && \
		chmod u+x nvim.appimage && \
		ln -sf nvim.appimage nvim
endif
