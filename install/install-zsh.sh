#!/bin/bash

# Install zsh if not already installed
if ! command -v "zsh" &> /dev/null; then
  echo 'zsh has not been installed. Installing...'
  if command -v "yum" &> /dev/null; then
    sudo yum install zsh -y
  elif command -v "apt" &> /dev/null; then
    sudo apt install zsh -y
  else
    echo 'Unknown distribution! Neither yum nor apt found.'
  fi
else
  echo 'zsh already installed. Skip.'
fi

# change default shell to zsh
USERNAME=$(whoami)
if [ "$SHELL" != "/bin/zsh" ]; then
  echo 'Changing default shell to zsh...'
  sudo chsh -s /bin/zsh "$USERNAME"
else
  echo 'Default shell already zsh. Skip.'
fi

# Copy zsh config files to $HOME/zsh/
CUR_SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
DOT_FILES_DIR="$(dirname "$CUR_SCRIPT_DIR")"
DOT_FILES_ZSH_DIR="$DOT_FILES_DIR/zsh"
DOT_FILES_FZF_DIR="$DOT_FILES_DIR/fzf"
cp "$DOT_FILES_ZSH_DIR/zshenv" "$HOME/.zshenv"
source "$HOME/.zshenv"

mkdir -p "$ZDOTDIR"
cp -r "$DOT_FILES_ZSH_DIR" "$XDG_CONFIG_HOME"

# Install Oh My Zsh if not already installed
if [ ! -f "$ZSH"/oh-my-zsh.sh ]; then
  echo 'oh-my-zsh has not been installed. Installing...'
  export RUNZSH=no
  export CHSH=no
  export KEEP_ZSHRC=yes
  sh -c "$(curl -fsSL https://gitee.com/Devkings/oh_my_zsh_install/raw/master/install.sh)"
fi

# Install plugins if not already installed
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting ]; then
  git clone https://gitee.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions ]; then
  git clone https://gitee.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k ]; then
  git clone https://gitee.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
fi

#############
#    fzf    #
#############
if [ ! -d "$HOME/.fzf" ] ||  ! command -v "fzf" &>/dev/null ; then
  git clone --depth 1 https://gitee.com/dictxiong/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --all --no-zsh
fi

if ! command -v "rg" &> /dev/null; then
  echo 'RipGrep has not been installed. Installing...'
  if command -v "yum" &> /dev/null; then
    sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
    sudo yum install ripgrep -y
  elif command -v "apt" &> /dev/null; then
    sudo apt install ripgrep -y
  else
    echo 'Unknown distribution! Neither yum nor apt found.'
  fi
else
  echo 'RigGrep already installed. Skip.'
fi

cp -r "$DOT_FILES_FZF_DIR" "$XDG_CONFIG_HOME/fzf"