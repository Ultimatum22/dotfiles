# Indicate that shell is running under Midnight Commander or ranger
if [[ -n "${MC_SID}" ]]; then
    _p10k_indicate_filemanager() {
        echo -n "[mc]"
    }
elif [[ -n "${RANGER_LEVEL}" ]]; then
    _p10k_indicate_filemanager() {
        echo -n "[ranger]"
    }
else
    _p10k_indicate_filemanager() { true; }
fi

# Indicate various virtual environments
_p10k_indicate_env() {
    if [[ -n "${VIRTUAL_ENV}" ]]; then
        echo -n "venv:${VIRTUAL_ENV:t}"
    else
        local wrapper
        local wrappers=(pyenv rbenv nodenv luaenv goenv plenv)
        for wrapper in "${wrappers[@]}"; do
            local wrapper_version="${wrapper:u}_VERSION"
            local wrapper_root="${wrapper:u}_ROOT"
            if [[ -n "${(P)wrapper_version}" ]]; then
                echo -n "${wrapper}-shell:${(P)wrapper_version}"
            elif [[ -n "${(P)wrapper_root}" ]]; then
                local wrapper_version_name=$(${wrapper} version-name)
                if [[ "${wrapper_version_name}" != "system" ]]; then
                    echo -n "${wrapper}:${wrapper_version_name}"
                fi
            fi
        done
    fi
}

# Enable powerlevel10k prompt
source "${ZDOTDIR}/plugins/powerlevel10k/powerlevel10k.zsh-theme"

# Temporarily change options
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
    emulate -L zsh
    setopt no_unset

    unset -m 'POWERLEVEL9K_*'

    # Load file manager indicator
    typeset -g POWERLEVEL9K_CUSTOM_FM="_p10k_indicate_filemanager"
    typeset -g POWERLEVEL9K_CUSTOM_FM_FOREGROUND="white"
    typeset -g POWERLEVEL9K_CUSTOM_FM_BACKGROUND=none

    # Load env wrapper indicator
    typeset -g POWERLEVEL9K_CUSTOM_MANY_ENV="_p10k_indicate_env"
    typeset -g POWERLEVEL9K_CUSTOM_MANY_ENV_FOREGROUND="green"
    typeset -g POWERLEVEL9K_CUSTOM_MANY_ENV_BACKGROUND=none

    # Configure left prompt
    typeset -ga POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        custom_fm context dir_writable dir vcs custom_many_env aws status command_execution_time background_jobs)

    # Disable right prompt
    typeset -g POWERLEVEL9K_DISABLE_RPROMPT=true

    local p='%#'
    local ok="%F{white}${p}%f"
    local err="%F{red}${p}%f"

    typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
    typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%(?.${ok}.${err}) "

    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
    typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
    typeset -g POWERLEVEL9K_WHITESPACE_BETWEEN_{LEFT,RIGHT}_SEGMENTS=

    typeset -g POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND=none
    typeset -g POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_VISUAL_IDENTIFIER_COLOR=003
    typeset -g POWERLEVEL9K_LOCK_ICON='#'

    typeset -g POWERLEVEL9K_DIR_{ETC,HOME,HOME_SUBFOLDER,DEFAULT}_BACKGROUND=none
    typeset -g POWERLEVEL9K_DIR_{ETC,DEFAULT}_FOREGROUND=209
    typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER}_FOREGROUND=039
    typeset -g POWERLEVEL9K_{ETC,FOLDER,HOME,HOME_SUB}_ICON=

    typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED,LOADING}_BACKGROUND=none
    typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=076
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=014
    typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=011
    typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=244
    typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_UNTRACKEDFORMAT_FOREGROUND=${POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND}
    typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_UNSTAGEDFORMAT_FOREGROUND=${POWERLEVEL9K_VCS_MODIFIED_FOREGROUND}
    typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_STAGEDFORMAT_FOREGROUND=${POWERLEVEL9K_VCS_MODIFIED_FOREGROUND}
    typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_INCOMING_CHANGESFORMAT_FOREGROUND=${POWERLEVEL9K_VCS_CLEAN_FOREGROUND}
    typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_OUTGOING_CHANGESFORMAT_FOREGROUND=${POWERLEVEL9K_VCS_CLEAN_FOREGROUND}
    typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_STASHFORMAT_FOREGROUND=${POWERLEVEL9K_VCS_CLEAN_FOREGROUND}
    typeset -g POWERLEVEL9K_VCS_{CLEAN,UNTRACKED,MODIFIED}_ACTIONFORMAT_FOREGROUND=001
    typeset -g POWERLEVEL9K_VCS_LOADING_ACTIONFORMAT_FOREGROUND=${POWERLEVEL9K_VCS_LOADING_FOREGROUND}
    typeset -g POWERLEVEL9K_VCS_{GIT,GIT_GITHUB,GIT_BITBUCKET,GIT_GITLAB,BRANCH}_ICON=
    typeset -g POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON=$'\b|'
    typeset -g POWERLEVEL9K_VCS_COMMIT_ICON='@'
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON=$'\b?'
    typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON=$'\b!'
    typeset -g POWERLEVEL9K_VCS_STAGED_ICON=$'\b+'
    typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='⇣'
    typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='⇡'
    typeset -g POWERLEVEL9K_VCS_STASH_ICON='*'
    typeset -g POWERLEVEL9K_VCS_TAG_ICON=$'\b#'

    typeset -g POWERLEVEL9K_STATUS_OK=false
    typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=none
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=009
    typeset -g POWERLEVEL9K_CARRIAGE_RETURN_ICON=

    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=none
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=101
    typeset -g POWERLEVEL9K_EXECUTION_TIME_ICON=

    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=none
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_COLOR=002
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_ICON='☰'

    typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,ROOT,REMOTE_SUDO,REMOTE,SUDO}_BACKGROUND=none
    typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,REMOTE_SUDO,REMOTE,SUDO}_FOREGROUND=244
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=011
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_CONTENT_EXPANSION='%7F%n%f%242F@%m%f'
    typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_CONTENT_EXPANSION='%242F%n@%m%f'
    typeset -g POWERLEVEL9K_CONTEXT_CONTENT_EXPANSION=
    typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true

    typeset -g POWERLEVEL9K_AWS_BACKGROUND=none
    typeset -g POWERLEVEL9K_AWS_FOREGROUND=208

    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
