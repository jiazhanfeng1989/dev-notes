---
id: zm1ggni3j9lzfk4jr8skae0
title: Uv
desc: ''
updated: 1753426901565
created: 1747879865550
---

# UV Description
[uv](https://github.com/astral-sh/uv) is an extremely fast Python package and project manager, written in Rust.

# UV Docs
- [uv doc](https://docs.astral.sh/uv)
- [uv 中文文档](https://hellowac.github.io/uv-zh-cn)

# UV Common Commands
## Python versions
Installing and managing Python itself.
``` text
uv python install: Install Python versions.
uv python list: View available Python versions.
uv python find: Find an installed Python version.
uv python pin: Pin the current project to use a specific Python version
uv python uninstall: Uninstall a Python version.
```
See the [guide on installing Python](https://docs.astral.sh/uv/guides/install-python/) to get started.

## Python Scripts
Executing standalone Python scripts, e.g., `example.py`.
``` text
uv run: Run a script.
uv add --script: Add a dependency to a script
uv remove --script: Remove a dependency from a script
```
See the [guide on running scripts](https://docs.astral.sh/uv/guides/scripts/) to get started.

## Python Projects
Creating and working on Python projects, i.e., with a pyproject.toml.
``` text
uv init: Create a new Python project.
uv add: Add a dependency to the project.
uv remove: Remove a dependency from the project.
uv sync: Sync the project's dependencies with the environment.
uv lock: Create a lockfile for the project's dependencies.
uv run: Run a command in the project environment.
uv tree: View the dependency tree for the project.
uv build: Build the project into distribution archives.
uv publish: Publish the project to a package index.
```
See the [guide on projects](https://docs.astral.sh/uv/guides/projects/) to get started.

## Tools
Running and installing tools published to Python package indexes, e.g., ruff or black
``` text
uvx / uv tool run: Run a tool in a temporary environment.
uv tool install: Install a tool user-wide.
uv tool uninstall: Uninstall a tool.
uv tool list: List installed tools.
uv tool update-text: Update the text to include tool executables.
```
See the [guide on tools](https://docs.astral.sh/uv/guides/tools/) to get started.

## The pip interface

Manually managing environments and packages
``` text
uv venv: Create a new virtual environment.
```
See the documentation on [using environments](https://docs.astral.sh/uv/pip/environments/) for details.

Managing packages in an environment
``` text
uv pip install: Install packages into the current environment.
uv pip show: Show details about an installed package.
uv pip freeze: List installed packages and their versions.
uv pip check: Check that the current environment has compatible packages.
uv pip list: List installed packages.
uv pip uninstall: Uninstall packages.
uv pip tree: View the dependency tree for the environment.
```
See the documentation on [managing packages](https://docs.astral.sh/uv/pip/packages/) for details.

## Utility
Managing and inspecting uv's state, such as the cache, storage directories, or performing a self-update:
``` text
uv cache clean: Remove cache entries.
uv cache prune: Remove outdated cache entries.
uv cache dir: Show the uv cache directory path.
uv tool dir: Show the uv tool directory path.
uv python dir: Show the uv installed Python versions path.
uv self update: Update uv to the latest version.
```


