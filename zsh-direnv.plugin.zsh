#!/usr/bin/env zsh

#####################
# COMMONS
#####################
autoload colors is-at-least

#########################
# CONSTANT
#########################
BOLD="bold"
NONE="NONE"

#########################
# PLUGIN MAIN
#########################

[[ -z "$DIRENV_HOME" ]] && export DIRENV_HOME="$HOME/.direnv/"

ZSH_DIRENV_VERSION_FILE=${DIRENV_HOME}/version.txt

#########################
# Functions
#########################

_zsh_direnv_log() {
  local font=$1
  local color=$2
  local msg=$3

  if [ $font = $BOLD ]
  then
    echo $fg_bold[$color] "[zsh-direnv-plugin] $msg" $reset_color
  else
    echo $fg[$color] "[zsh-direnv-plugin] $msg" $reset_color
  fi
}

_zsh_direnv_last_version() {
  echo $(curl -s https://api.github.com/repos/direnv/direnv/releases | grep tag_name | head -n 1 | cut -d '"' -f 4)
}

_zsh_direnv_download_install() {
    local version=$1
    local machine
    case "$(uname -m)" in
      x86_64)
        machine=amd64
        ;;
      i686 | i386)
        machine=386
        ;;
      *)
        _zsh_direnv_log $BOLD "red" "Machine $(uname -m) not supported by this plugin"   
        return 1
      ;;
    esac
    _zsh_direnv_log $NONE "blue" "  -> download and install direnv ${version}"
    wget -qc https://github.com/direnv/direnv/releases/download/${version}/direnv.${OSTYPE%-*}-${machine} -O "${DIRENV_HOME}/direnv"
    chmod +x "${DIRENV_HOME}/direnv"
    echo ${version} > ${ZSH_DIRENV_VERSION_FILE}
}

_zsh_direnv_install() {
  _zsh_direnv_log $NONE "blue" "#############################################"
  _zsh_direnv_log $BOLD "blue" "Installing direnv..." 
  _zsh_direnv_log $NONE "blue" "-> creating direnv home dir : ${DIRENV_HOME}"  
  mkdir -p ${DIRENV_HOME} || _zsh_direnv_log $NONE "green" "dir already exist"
  local last_version=$(_zsh_direnv_last_version)
  _zsh_direnv_log $NONE "blue" "-> retrieve last version of direnv..."
  _zsh_direnv_download_install ${last_version}
  if [ $? -ne 0 ]
  then 
    _zsh_direnv_log $BOLD "red" "Install KO"
  else
    _zsh_direnv_log $BOLD "green" "Install OK"
  fi
  _zsh_direnv_log $NONE "blue" "#############################################"
}

update_zsh_direnv() {
  _zsh_direnv_log $NONE "blue" "#############################################"
  _zsh_direnv_log $BOLD "blue" "Checking new version of direnv..."
  
  local current_version=$(cat ${ZSH_DIRENV_VERSION_FILE})
  local last_version=$(_zsh_direnv_last_version)

  if is-at-least ${last_version#v*} ${current_version#v*}
  then
    _zsh_direnv_log $BOLD "green" "Already up to date, current version : ${current_version}"
  else
    _zsh_direnv_log $NONE "blue" "-> Updating direnv..." 
    _zsh_direnv_download_install ${last_version}
    _zsh_direnv_log $BOLD "green" "Update OK"
  fi
  _zsh_direnv_log $NONE "blue" "#############################################"
}

_zsh_direnv_load() {
    # export PATH
    export PATH=${PATH}:${DIRENV_HOME}
    eval "$(direnv hook zsh)"
}

# install direnv if it isnt already installed
[[ ! -f "${ZSH_DIRENV_VERSION_FILE}" ]] && _zsh_direnv_install

# load direnv if it is installed
if [[ -f "${ZSH_DIRENV_VERSION_FILE}" ]]; then
    _zsh_direnv_load
fi

unset -f _zsh_direnv_install _zsh_direnv_load