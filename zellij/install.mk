.PHONY: zellij
ALL_TARGETS += zellij

zellij: ## Install zellij config
	./install_file.sh zellij/config.kdl ~/.config/zellij/config.kdl
