#!/bin/sh

setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
stty stop undef # Disable ctrl-s to freeze terminal

unsetopt BEEP

# Completions
autoload -Uz compinit
zstyle ':completion:*' menu select

zmodload zsh/complist

_comp_options+=(globdots) # Include hidden files

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Colors
autoload -Uz colors && colors

# Functions
source "$ZDOTDIR/zsh-functions"

# Normal files to source
# zsh_add_file "zsh-exports"
#zsh_add_file "zsh-vim-mode"
# zsh_add_file "zsh-aliases"
# zsh_add_file "zsh-prompt"

# Plugins
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_completion "esc/conda-zsh-completion" false

# Kkey-bindings
#bindkey -s '^o' ranger^M'