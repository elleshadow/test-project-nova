# Makefile for general-purpose project management

# Variables
SHELL := /bin/bash
PROJECT_NAME := myproject
PYTHON := python3
PIP := pip3
VENV_NAME := venv
VENV_ACTIVATE := $(VENV_NAME)/bin/activate
VENV_PYTHON := $(VENV_NAME)/bin/python
VENV_PIP := $(VENV_NAME)/bin/pip
DOCKER := docker
DOCKER_IMAGE := $(PROJECT_NAME):latest
CHANGELOG := CHANGELOG.md

# Colors for terminal output
CYAN := \033[0;36m
NO_COLOR := \033[0m

# Phony targets
.PHONY: all setup venv install update build test run clean docker-build docker-run deploy help

# Default target
all: setup venv install build test

# Setup the project
setup:
	@echo -e "$(CYAN)Setting up the project...$(NO_COLOR)"
	@mkdir -p src tests docs
	@echo "### Added" >> $(CHANGELOG)
	@echo "- Initial project structure (src, tests, docs directories)" >> $(CHANGELOG)
	@echo "Project setup complete."

# Create virtual environment
venv:
	@echo -e "$(CYAN)Creating virtual environment...$(NO_COLOR)"
	@$(PYTHON) -m venv $(VENV_NAME)
	@echo "- Created virtual environment" >> $(CHANGELOG)
	@echo "Virtual environment created. Activate with 'source $(VENV_ACTIVATE)'"

# Install dependencies
install: venv
	@echo -e "$(CYAN)Installing dependencies...$(NO_COLOR)"
	@source $(VENV_ACTIVATE) && \
	if [ -f requirements.txt ]; then \
		$(VENV_PIP) install -r requirements.txt && \
		echo "- Installed dependencies from requirements.txt" >> $(CHANGELOG); \
	elif [ -f setup.py ]; then \
		$(VENV_PIP) install -e . && \
		echo "- Installed project in editable mode" >> $(CHANGELOG); \
	else \
		echo "No requirements.txt or setup.py found."; \
	fi

# Update dependencies
update: venv
	@echo -e "$(CYAN)Updating dependencies...$(NO_COLOR)"
	@source $(VENV_ACTIVATE) && \
	if [ -f requirements.txt ]; then \
		$(VENV_PIP) install --upgrade -r requirements.txt && \
		echo "- Updated dependencies from requirements.txt" >> $(CHANGELOG); \
	elif [ -f setup.py ]; then \
		$(VENV_PIP) install --upgrade -e . && \
		echo "- Updated project dependencies" >> $(CHANGELOG); \
	else \
		echo "No requirements.txt or setup.py found."; \
	fi

# Build the project
build: venv
	@echo -e "$(CYAN)Building the project...$(NO_COLOR)"
	@source $(VENV_ACTIVATE) && \
	if [ -f setup.py ]; then \
		$(VENV_PYTHON) setup.py build && \
		echo "- Built the project" >> $(CHANGELOG); \
	else \
		echo "No build process defined."; \
	fi

# Run tests
test: venv
	@echo -e "$(CYAN)Running tests...$(NO_COLOR)"
	@source $(VENV_ACTIVATE) && \
	if [ -d tests ]; then \
		$(VENV_PYTHON) -m pytest tests && \
		echo "- Ran test suite" >> $(CHANGELOG); \
	else \
		echo "No tests found."; \
	fi

# Run the project
run: venv
	@echo -e "$(CYAN)Running the project...$(NO_COLOR)"
	@source $(VENV_ACTIVATE) && \
	if [ -f main.py ]; then \
		$(VENV_PYTHON) main.py; \
	else \
		echo "No run command defined."; \
	fi

# Clean build artifacts and virtual environment
clean:
	@echo -e "$(CYAN)Cleaning build artifacts and virtual environment...$(NO_COLOR)"
	@rm -rf build dist *.egg-info .pytest_cache $(VENV_NAME)
	@find . -type f -name '*.pyc' -delete
	@find . -type d -name '__pycache__' -delete
	@echo "- Cleaned build artifacts and virtual environment" >> $(CHANGELOG)

# Build Docker image
docker-build:
	@echo -e "$(CYAN)Building Docker image...$(NO_COLOR)"
	@$(DOCKER) build -t $(DOCKER_IMAGE) .
	@echo "- Built Docker image" >> $(CHANGELOG)

# Run Docker container
docker-run:
	@echo -e "$(CYAN)Running Docker container...$(NO_COLOR)"
	@$(DOCKER) run -it --rm $(DOCKER_IMAGE)

# Deploy the project (placeholder)
deploy:
	@echo -e "$(CYAN)Deploying the project...$(NO_COLOR)"
	@echo "Deployment process not defined. Please implement your deployment strategy."
	@echo "- Attempted deployment (process not defined)" >> $(CHANGELOG)

# Help target
help:
	@echo -e "$(CYAN)Available targets:$(NO_COLOR)"
	@echo "  setup        - Set up the initial project structure"
	@echo "  venv         - Create a virtual environment"
	@echo "  install      - Install project dependencies in the virtual environment"
	@echo "  update       - Update project dependencies in the virtual environment"
	@echo "  build        - Build the project using the virtual environment"
	@echo "  test         - Run tests using the virtual environment"
	@echo "  run          - Run the project using the virtual environment"
	@echo "  clean        - Clean build artifacts and remove virtual environment"
	@echo "  docker-build - Build Docker image"
	@echo "  docker-run   - Run Docker container"
	@echo "  deploy       - Deploy the project (placeholder)"
	@echo "  help         - Show this help message"