.PHONY: nvim update-nvim
ALL_TARGETS += nvim

nvim:
	./install_file.sh nvim/init.lua       ~/.config/nvim/init.lua
	./install_dir.sh  nvim/lua            ~/.config/nvim/lua
	./install_dir.sh  nvim/lua/plugins    ~/.config/nvim/lua/plugins
	./install_dir.sh  nvim/after/ftplugin ~/.config/nvim/after/ftplugin

# If this is 1 on Linux, then download a version which works with older glibc.
OLD_GLIBC ?= 0
OS := $(shell uname -s)
ARCH := $(shell uname -m)
ifeq ($(OS),Darwin)
NVIM_REPO := neovim
else ifeq ($(OLD_GLIBC),0)
NVIM_REPO := neovim
else
NVIM_REPO := neovim-releases
endif
NVIM_URL := https://github.com/neovim/$(NVIM_REPO)/releases/download/nightly

# Update to latest nightly build of neovim for macOS/Linux
update-nvim:
ifeq ($(OS),Darwin)
	curl -fLO $(NVIM_URL)/nvim-macos-$(ARCH).tar.gz && \
		xattr -c ./nvim-macos-$(ARCH).tar.gz && \
		tar xzf nvim-macos-$(ARCH).tar.gz && \
		rm -rf ~/.local/nvim-macos-$(ARCH) && \
		mv nvim-macos-$(ARCH) ~/.local/ && \
		rm ./nvim-macos-$(ARCH).tar.gz
else
	curl -fLO $(NVIM_URL)/nvim-linux-$(ARCH).appimage && \
		mv nvim-linux-$(ARCH).appimage ~/.local/bin && \
		cd ~/.local/bin && \
		chmod u+x nvim-linux-$(ARCH).appimage && \
		ln -sf nvim-linux-$(ARCH).appimage nvim
endif
