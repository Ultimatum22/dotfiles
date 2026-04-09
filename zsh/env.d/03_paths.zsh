# Add custom functions and completions
fpath=(${ZDOTDIR}/fpath ${fpath})

# Ensure we have local paths enabled
path=(/usr/local/bin /usr/local/sbin ${path})

# Enable local binaries and man pages
path=(${HOME}/.local/bin ${path})
MANPATH="${XDG_DATA_HOME}/man:${MANPATH}"

# Conda — lazy init on first call
conda() {
    unset -f conda
    local _conda_setup
    _conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$_conda_setup"
    elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
    conda "$@"
}

# NVM
[[ -f /usr/share/nvm/nvm.sh ]] && source /usr/share/nvm/nvm.sh
[[ -f /usr/share/nvm/bash_completion ]] && source /usr/share/nvm/bash_completion
[[ -f /usr/share/nvm/install-nvm-exec ]] && source /usr/share/nvm/install-nvm-exec

# SDK — lazy init on first call
sdk() {
    unset -f sdk
    [[ -f "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk "$@"
}

# Add go binaries to paths
path=(${GOROOT}/bin ${GOPATH}/bin ${FLUTTER}/bin ${ANDROID_PLATFORM_TOOLS} ${MAVEN}/bin ${path})
