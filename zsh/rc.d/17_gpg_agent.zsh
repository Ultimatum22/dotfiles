# remind gpg-agent to update current tty for new shell session
if (( ${+commands[gpg-connect-agent]} )) && pgrep -u "${EUID}" gpg-agent &>/dev/null; then
    gpg-connect-agent --quiet --no-history updatestartuptty /bye >/dev/null
fi
