.PHONY: python
ALL_TARGETS += python

python: ## Install Python REPL config
	./install_file.sh python/inputrc   ~/.inputrc
	./install_file.sh python/pystartup ~/.pystartup
