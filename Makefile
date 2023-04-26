SHELL:=/usr/bin/env bash
GITHUB_ACTION_TEST ?= no

.PHONY: lint package unit test init-testdb init-devdb

format:
	poetry run isort .
	poetry run black .

mypy: format
	poetry run mypy .

flake: mypy
	poetry run flake8 .

lint: format mypy flake

package:
	poetry check
	poetry run pip check
	# poetry run safety check -i 51668 -i 51499 --full-report

sunit:
	poetry run pytest -s tests

unit:
	poetry run pytest tests

test: lint package unit

.PHONY: clean clean-build clean-pyc clean-test
clean: clean-build clean-pyc clean-test ## remove all build, test, coverage and Python artifacts

clean-build: ## remove build artifacts
	rm -fr build/
	rm -fr docs/_build
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -f {} +

clean-pyc: ## remove Python file artifacts
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test: ## remove test and coverage artifacts
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/
	rm -fr .pytest_cache
	rm -fr .mypy_cache
