#!/usr/bin/env zsh

set -e

zmodload -m -F zsh/files b:zf_\*

# Get the current path
SCRIPT_DIR="${0:A:h}"
cd "${SCRIPT_DIR}"

# Default XDG paths
XDG_CACHE_HOME="${HOME}/.cache"
XDG_CONFIG_HOME="${HOME}/.config"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"

# Create required directories
print "Creating required directory tree..."
zf_mkdir -p "${XDG_CONFIG_HOME}"/{git/local,mc,htop,ranger,gem,tig,gnupg,nvim}
zf_mkdir -p "${XDG_CACHE_HOME}"/{vim/{backup,swap,undo},zsh,tig}
zf_mkdir -p "${XDG_DATA_HOME}"/{{goenv,jenv,luaenv,nodenv,phpenv,plenv,pyenv,rbenv}/plugins,zsh,man/man1,vim/spell,nvim/site/pack/plugins}
zf_mkdir -p "${XDG_STATE_HOME}"
zf_mkdir -p "${HOME}"/.local/{bin,etc}
zf_chmod 700 "${XDG_CONFIG_HOME}/gnupg"
print "  ...done"

# Link zshenv if needed
print "Checking for ZDOTDIR env variable..."
if [[ "${ZDOTDIR}" = "${SCRIPT_DIR}/zsh" ]]; then
    print "  ...present and valid, skipping .zshenv symlink"
else
    ln -sf "${SCRIPT_DIR}/zsh/.zshenv" "${ZDOTDIR:-${HOME}}/.zshenv"
    print "  ...failed to match this script dir, symlinking .zshenv"
fi

# Link config files
print "Linking config files..."
zf_ln -sfn "${SCRIPT_DIR}/vim" "${XDG_CONFIG_HOME}/vim"
zf_ln -sf "${SCRIPT_DIR}/nvim/init.lua" "${XDG_CONFIG_HOME}/nvim/init.lua"
zf_ln -sfn "${SCRIPT_DIR}/nvim/after" "${XDG_CONFIG_HOME}/nvim/after"
zf_ln -sfn "${SCRIPT_DIR}/nvim/lua" "${XDG_CONFIG_HOME}/nvim/lua"
zf_ln -sfn "${SCRIPT_DIR}/nvim/plugins" "${XDG_DATA_HOME}/nvim/site/pack/plugins/start"
zf_ln -sf "${SCRIPT_DIR}/configs/gitconfig" "${XDG_CONFIG_HOME}/git/config"
zf_ln -sf "${SCRIPT_DIR}/configs/gitattributes" "${XDG_CONFIG_HOME}/git/attributes"
zf_ln -sf "${SCRIPT_DIR}/configs/gitignore" "${XDG_CONFIG_HOME}/git/ignore"
zf_ln -sf "${SCRIPT_DIR}/configs/mc.ini" "${XDG_CONFIG_HOME}/mc/ini"
zf_ln -sf "${SCRIPT_DIR}/configs/htoprc" "${XDG_CONFIG_HOME}/htop/htoprc"
zf_ln -sf "${SCRIPT_DIR}/configs/ranger" "${XDG_CONFIG_HOME}/ranger/rc.conf"
zf_ln -sf "${SCRIPT_DIR}/configs/gemrc" "${XDG_CONFIG_HOME}/gem/gemrc"
zf_ln -snf "${SCRIPT_DIR}/configs/ranger-plugins" "${XDG_CONFIG_HOME}/ranger/plugins"
zf_ln -sf "${SCRIPT_DIR}/configs/i3" "${XDG_CONFIG_HOME}/i3"
zf_ln -sf "${SCRIPT_DIR}/configs/i3status-rust" "${XDG_CONFIG_HOME}/i3status-rust"
zf_ln -sf "${SCRIPT_DIR}/configs/alacritty" "${XDG_CONFIG_HOME}/alacritty"
print "  ...done"

# Make sure submodules are installed
print "Syncing submodules..."
git submodule sync > /dev/null
git submodule update --init --recursive > /dev/null
git clean -ffd
print "  ...done"

print "Compiling zsh plugins..."
{
    emulate -LR zsh
    setopt local_options extended_glob
    autoload -Uz zrecompile
    for plugin_file in ${SCRIPT_DIR}/zsh/plugins/**/*.zsh{-theme,}(#q.); do
        zrecompile -pq "${plugin_file}"
    done
}
print "  ...done"

# Install hook to call deploy script after successful pull
print "Installing git hooks..."
zf_mkdir -p .git/hooks
zf_ln -sf ../../deploy.zsh .git/hooks/post-merge
zf_ln -sf ../../deploy.zsh .git/hooks/post-checkout
print "  ...done"

if (( ${+commands[make]} )); then
    # Make install git-extras
    print "Installing git-extras..."
    pushd tools/git-extras
    PREFIX="${HOME}/.local" make install > /dev/null
    popd
    print "  ...done"

    print "Installing git-quick-stats..."
    pushd tools/git-quick-stats
    PREFIX="${HOME}/.local" make install > /dev/null
    popd
    print "  ...done"
fi

# Link gpg configs to $GNUPGHOME
print "Linking gnupg configs..."
zf_ln -sf "${SCRIPT_DIR}/gpg/gpg.conf" "${XDG_CONFIG_HOME}/gnupg/gpg.conf"
zf_ln -sf "${SCRIPT_DIR}/gpg/gpg-agent.conf" "${XDG_CONFIG_HOME}/gnupg/gpg-agent.conf"
print "  ...done"

print "Installing fzf..."
pushd tools/fzf
if ./install --bin > /dev/null; then
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf" "${HOME}/.local/bin/fzf"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/bin/fzf-tmux" "${HOME}/.local/bin/fzf-tmux"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf.1" "${XDG_DATA_HOME}/man/man1/fzf.1"
    zf_ln -sf "${SCRIPT_DIR}/tools/fzf/man/man1/fzf-tmux.1" "${XDG_DATA_HOME}/man/man1/fzf-tmux.1"
    print "  ...done"
else
    print "  ...failed. Probably unsupported architecture, please check fzf installation guide"
fi
popd

if (( ${+commands[perl]} )); then
    # Install diff-so-fancy
    print "Installing diff-so-fancy..."
    zf_ln -sf "${SCRIPT_DIR}/tools/diff-so-fancy/diff-so-fancy" "${HOME}/.local/bin/diff-so-fancy"
    print "  ...done"
fi

if (( ${+commands[vim]} )); then
    # Generate vim help tags
    print "Generating vim helptags..."
    command vim --not-a-term -c "helptags ALL" -c "qall" &> /dev/null
    print "  ...done"
fi

if (( ${+commands[nvim]} )); then
    # Generate nvim help tags
    print "Generating nvim helptags..."
    command nvim --headless -c "helptags ALL" -c "qall" &> /dev/null
    print "  ...done"
    # Update treesitter config
    print "Updating treesitter config..."
    command nvim --headless -c "TSUpdate" -c "qall" &> /dev/null
    print "  ...done"
    # Update mason registries
    print "Updating mason registries..."
    command nvim --headless -c "MasonUpdate" -c "qall" &> /dev/null
    print "  ...done"
fi

# Trigger zsh run with powerlevel10k prompt to download gitstatusd
print "Downloading gitstatusd for powerlevel10k..."
${SHELL} -is <<<'' &> /dev/null
print "  ...done"

# Download/refresh TLDR pages
print "Downloading TLDR pages..."
${SCRIPT_DIR}/tools/tldr-bash-client/tldr -u > /dev/null
print "  ...done"

# Install crontab task to pull updates every midnight
print "Installing cron job for periodic updates..."
local cron_task="cd ${SCRIPT_DIR} && git -c user.name=cron.update -c user.email=cron@localhost stash && git pull && git stash pop"
local cron_schedule="0 0 * * * ${cron_task}"
if cat <(grep --ignore-case --invert-match --fixed-strings "${cron_task}" <(crontab -l)) <(echo "${cron_schedule}") | crontab -; then
    print "  ...done"
else
    print "Please add \`cd ${SCRIPT_DIR} && git pull\` to your crontab or just ignore this, you can always update dotfiles manually"
fi
