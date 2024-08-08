.PHONY: python
ALL_TARGETS += python

python:
	./install_file.sh python/inputrc   ~/.inputrc
	./install_file.sh python/pystartup ~/.pystartup
