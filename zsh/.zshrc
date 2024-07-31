#!/usr/bin/env zsh

plugins=(git fzf zsh-syntax-highlighting zsh-autosuggestions)

autoload -U compinit; compinit

source "$ZSH"/oh-my-zsh.sh
source "$ZDOTDIR"/aliases
source "$ZDOTDIR"/bd.zsh
source "$ZDOTDIR"/fzf.zsh

. "$ZDOTDIR"/z.sh

if [ $ZSH_THEME = "robbyrussell" ];
then
  PROMPT="%U%F{yellow}%n@%m%f%u %(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"
  PROMPT+=' %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'
  export PROMPT="$PROMPT"
elif [ $ZSH_THEME = "powerlevel10k/powerlevel10k" ];
then
  [[ ! -f "$ZDOTDIR"/.p10k.zsh ]] || source "$ZDOTDIR"/.p10k.zsh
fi