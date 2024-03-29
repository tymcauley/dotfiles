.PHONY: python
ALL_TARGETS += python

python:
	./install_file.sh python/inputrc   ~/.inputrc
	./install_file.sh python/pystartup ~/.pystartup
ifneq ($(strip $(PYTHON_PACKAGES)),)
	python3 -m pip install --upgrade --quiet pip
	python3 -m pip install --upgrade --quiet $(PYTHON_PACKAGES)
endif
