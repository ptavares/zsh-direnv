# Contributing

:+1: :tada: First off, thanks for taking the time to contribute! :tada: :+1:

The following is a set of guidelines for contributing to **zsh-direnv**. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Table of Content

<!--TOC-->

- [Contributing](#contributing)
  - [Table of Content](#table-of-content)
  - [Developers Information](#developers-information)
  - [Tools used](#tools-used)
    - [Pre-commit](#pre-commit)
    - [Makefile Usage](#makefile-usage)
  - [Styleguides](#styleguides)
    - [Git Commit Messages](#git-commit-messages)
    - [Documentation Styleguide](#documentation-styleguide)

<!--TOC-->

## Tools used

### Pre-commit

To facilitate testing before committing, you have the option of running automated tests with pre-commit. Each hook enables a test that we can customize.

#### The main hooks configured

##### Linting

###### md-toc

To ensure an automatic generation of markdown *Table of content*, the `md-toc` hook is used.

#### Install dependencies

* [`pre-commit`](https://pre-commit.com/#install)

#### Usage Pre-commit

To execution automated on commit you can install pre-commit on your repo folder

```bash
pre-commit install
```

To perform code test manually, you must run the pre-commit before pushing your code
like this:

```bash
pre-commit install
pre-commit run --all
```

### Makefile

#### Install dependencies

* [`docker`](https://docs.docker.com/get-docker/)

#### Usage

:warning: **Warning** : Don't tag manually.

```bash
> make help

default                     Default Task, build program with default values
version                     Get current version
check-status                Check current git status
check-release               Check release status
major-release               Do a major-release, ie : bumped first digit X+1.y.z
minor-release               Do a minor-release, ie : bumped second digit x.Y+1.z
patch-release               Do a patch-release, ie : bumped third digit x.y.Z+1
precommit                   Execute some checks with pre-commit hooks
help                        Show this help (Run make <target> V=1 to enable verbose)
```

## Styleguides

### Git Commit Messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit commit title to 48 characters or less
* Reference issues and pull requests liberally in commit title/message
* Consider starting the commit message with an applicable [emoji](https://gitmoji.dev/) like :
    * :sparkles: `:sparkles:` when introducing new features
    * :recycle: `:recycle:` when refactoring code
    * :art: `:art:` when improving the format/structure of the code
    * :zap: `:zap:` when improving performance
    * :memo: `:memo:` when writing docs
    * :bug: `:bug:` when fixing a bug
    * :fire: `:fire:` when removing code or files
    * :green_heart: `:green_heart:` when fixing the CI build
    * :pushpin: `:pushpin:` when pinning dependencies to specific version
    * :arrow_up: `:arrow_up:` when upgrading dependencies
    * :arrow_down: `:arrow_down:` when downgrading dependencies
    * :rotating_light: `:rotating_light:` when removing linter warnings

### Changelog

Changelog is generated automatically (based on [gitmoji-changelog](https://github.com/frinyvonnick/gitmoji-changelog)) when building a new release.


### Documentation Styleguide

* Use [Markdown](https://daringfireball.net/projects/markdown).
