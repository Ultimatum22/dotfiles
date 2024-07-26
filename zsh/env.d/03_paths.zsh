# Add custom functions and completions
fpath=(${ZDOTDIR}/fpath ${fpath})

# Ensure we have local paths enabled
path=(/usr/local/bin /usr/local/sbin ${path})

# Enable local binaries and man pages
path=(${HOME}/.local/bin ${path})
MANPATH="${XDG_DATA_HOME}/man:${MANPATH}"

# Add go binaries to paths
path=(${GOPATH}/bin ${FLUTTER}/bin ${ANDROID_PLATFORM_TOOLS} ${path})
