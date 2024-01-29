.DEFAULT_GOAL := help

PROJECT_NAME=$(shell grep "name" pyproject.toml | cut -d "\"" -f 2)

# Misc --------------------------------------------------------------------------------------------

all: clean setup check tests future

help:
	@# Got it from here: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; \
	{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Cleanup -----------------------------------------------------------------------------------------

clean: ## Resets the development environment to the initial state
	-find . -name "*.pyc" -delete
	find . -type d -name '__pycache__' -exec rm -r {} +
	-rm requirements.txt
	-rm dist/${PROJECT_NAME}*
	-poetry env remove --quiet --all
	-rm -rf build
	-rm -rf .mypy_cache
	-rm -rf .nox
	-rm -rf .pytest_cache
	-rm -r .coverage
	-rm -r htmlcov

# Dependency Management ---------------------------------------------------------------------------

deps: ## Installs project dependencies
	poetry install --no-root

deps-outdated: ## Shows outdated dependencies
	poetry show --outdated

updatelatest: ## Update dependencies to latest available compatible versions
	poetry up --pinned --latest

# Configuration -----------------------------------------------------------------------------------

setup: deps ## Sets up the development environment

# Static checks -----------------------------------------------------------------------------------

check: ## Runs static checks on the code

# Tests -------------------------------------------------------------------------------------------

tests: ## Runs all the tests
	docker compose down
	docker compose up -d
	curl --retry 5 --retry-all-errors --retry-delay 1 "http://127.0.0.1:80"
	docker compose down

future: ## Tests the code against multiple python versions
	poetry export -f requirements.txt --output requirements.txt --with dev
	poetry run nox
	-rm requirements.txt

# Environment -------------------------------------------------------------------------------------

dev-run: ## Runs the project in the development environment
	docker compose down
	docker compose up -d


