.PHONY: install-hooks check

install-hooks:
	pre-commit install

check:
	pre-commit run --all-files
