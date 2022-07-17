[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
![Release](https://img.shields.io/badge/Release_version-0.1.3-blue)

# zsh-direnv

zsh plugin for installing and loading [direnv](https://github.com/direnv/direnv.git)
>Inpired by [zsh-pyenv](https://github.com/mattberther/zsh-pyenv)
>
## Table of content

_This documentation section is generated automatically_

<!--TOC-->

- [zsh-direnv](#zsh-direnv)
  - [Table of content](#table-of-content)
  - [Supported Operating system](#supported-operating-system)
  - [Usage](#usage)
  - [Updating direnv](#updating-direnv)
  - [License](#license)

<!--TOC-->

## Supported Operating system

List of Operating System currently supported by the plugin:

- :penguin: Linux
  - amd64
  - arm64
- :apple: Darwin
  - amd64
  - arm64

## Usage

Once the plugin installed, `direnv` will be available

- Using [Antigen](https://github.com/zsh-users/antigen)

Bundle `zsh-direnv` in your `.zshrc`

```shell
antigen bundle ptavares/zsh-direnv
```

- Using [zplug](https://github.com/b4b4r07/zplug)

Load `zsh-direnv` as a plugin in your `.zshrc`

```shell
zplug "ptavares/zsh-direnv"
```

- Using [zgen](https://github.com/tarjoilija/zgen)

Include the load command in your `.zshrc`

```shell
zget load ptavares/zsh-direnv
```

- As an [Oh My ZSH!](https://github.com/robbyrussell/oh-my-zsh) custom plugin

Clone `zsh-direnv` into your custom plugins repo and load as a plugin in your `.zshrc`

```shell
git clone https://github.com/ptavares/zsh-direnv.git ~/.oh-my-zsh/custom/plugins/zsh-direnv
```

```shell
plugins+=(zsh-direnv)
```

Keep in mind that plugins need to be added before `oh-my-zsh.sh` is sourced.

- Manually

Clone this repository somewhere (`~/.zsh-direnv` for example) and source it in your `.zshrc`

```shell
git clone https://github.com/ptavares/zsh-direnv ~/.zsh-direnv
```

```shell
source ~/.zsh-direnv/zsh-direnv.plugin.zsh
```

## Updating direnv

The plugin comes with a zsh function to update [direnv](https://github.com/direnv/direnv.git) manually

```shell
# From zsh shell
update_zsh_direnv
```

## License

[MIT](LICENCE)
