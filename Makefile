SHELL := $(shell which bash)
VENV_DEV := .venv
VENV_TEST_LOCAL := .venv-test-local
VENV_TEST_PYPI := .venv-test-pypi

.PHONY: all
all: clean lint build test-local ## Run a clean build

.PHONY: lint
lint: ## Lint the Python code ./src
	pylint ./src

.PHONY: build
build: ## Build the package
	python3 -m build

.PHONY: test-local
test-local: ## Test a local installation
	python3 -m venv ${VENV_TEST_LOCAL}
	${VENV_TEST_LOCAL}/bin/pip -v install dist/airthings-mqtt-*.tar.gz
	source ${VENV_TEST_LOCAL}/bin/activate && airthings-mqtt --version

.PHONY: test-pypi
test-pypi: ## Test an installation from PyPI test
	python3 -m venv ${VENV_TEST_PYPI}
	${VENV_TEST_PYPI}/bin/pip install -i https://testpypi.python.org/pypi airthings-mqtt
	source ${VENV_TEST_PYPI}/bin/activate && airthings-mqtt --version

.PHONY: upload-testpypi
upload-testpypi: ## Upload toe test PyPI
	python3 -m twine upload --repository testpypi dist/*

.PHONY: upload-pypi
upload-pypi: ## Upload to PyPI
	python3 -m twine upload --repository pypi dist/*

.PHONY: clean
clean: ## Remove all generated files
	rm -rf dist build src/${PKG}.egg-info
	rm -rf ${VENV_TEST_LOCAL} ${VENV_TEST_PYPI}

.PHONY: devel-env
devel-env: build ## Prepare a venv for development
	python3 -m venv .venv
	source .venv/bin/activate && pip3 install -r requirements.txt
	source .venv/bin/activate && pip3 install .
	source .venv/bin/activate && airthings-mqtt --version

.PHONY: install-debian
install-debian: install-debian-dependencies ## Install on a debian based host
	# create a venv
	sudo mkdir /opt/airthings-mqtt
	sudo python3 -m venv /opt/airthings-mqtt/.venv
	sudo source /opt/airthings-mqtt/.venv && pip3 install .
	cp config/config-example.yml /opt/airthings-mqtt/config.yml
	# TODO: scan for devices
	# TODO: ask use to select devices
	# TODO: ask user for MQTT host, port and credentials
	# TODO: add cronjob

.PHONY: install-debian-dependencies
install-debian-dependencies: ## Install dependencies on debian
	# Install dependencies from apt repo
	sudo apt-get update
	sudo apt-get install python3-pip libglib2.0-dev python3-virtualenv

# This will try to find targets with ## after the prerequisites and then add
# the target name and the comment (after the ##) in the usage section.
# Finally it will add all declared variables.
.PHONY: help
help: ## Display this help
	@# Adapted from https://www.thapaliya.com/en/writings/well-documented-makefiles/
	@printf "Usage:\n  make \033[36m[target]\033[0m [variable]...\n\n"
	@printf "Targets:\n"
	@awk -F':.*##' ' \
	/^[a-zA-Z_-]+:.*?##/ { \
    	printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 \
	} \
	' $(MAKEFILE_LIST) | sort
	@printf "\n"
	@printf "Variables:\n"
	@sed -rn 's/^([^[:space:]]*=.*)/  \1/p' $(MAKEFILE_LIST) | sort
