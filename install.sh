if [ -z "$DOTFILES" ]; then
  export DOTFILES="${HOME}/.dotfiles"
fi

ln -fs "$DOTFILES/zsh/.zshenv" "$HOME/.zshenv"
source "$HOME/.zshenv"

ln -fs "$DOTFILES/zsh/.zshrc" "$ZDOTDIR/.zshrc"
ln -fs "$DOTFILES/zsh/zsh-functions" "$ZDOTDIR/zsh-functions"
ln -fs "$DOTFILES/zsh/zsh-aliases" "$ZDOTDIR/zsh-aliases"
ln -fs "$DOTFILES/zsh/zsh-exports" "$ZDOTDIR/zsh-exports"
ln -fs "$DOTFILES/zsh/zsh-prompt" "$ZDOTDIR/zsh-prompt"