# ✚ ✹ ✖ ➜ ═ ✭

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}*"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}>"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}="
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}@"
ZSH_GIT_PROMPT_SHOW_STASH=1

turquoise="%F{81}"
orange="%F{166}"
purple="%F{135}"
hotpink="%F{161}"
limegreen="%F{118}"
gray235="%F{235}"
gray235="%F{235}"
gray237="%F{237}"
gray240="%F{240}"
gray250="%F{250}"
gray255="%F{255}"

BLOCK_BEFORE="%{$gray237%}"
BLOCK_AFTER="%{$gray237%}"


function current_dir() {
    echo "%{$hotpink%}%1~"
}

function path_without_last_dir() {
    local path="${PWD/#$HOME/~}"  # Replace the home directory path with ~
    
    if [[ "$path" != "~" ]]; then
        echo "$(empty_space)$BLOCK_BEFORE%{$gray240%}${path%/*}$BLOCK_AFTER"
    fi
}

function git_changes() {
    if [[ -n $(git_prompt_status) ]]; then
        echo " ~ $(git_prompt_status)"
    fi
}

function git_print_details() {
    if [[ -n $(git_current_branch) ]]; then
        echo "$(empty_space)$BLOCK_BEFORE%{$gray240%}$(git_current_branch) $(git_prompt_short_sha)$(git_changes)$BLOCK_AFTER"
    fi
}


function nvm_info() {
    if [[ -n $NVM_BIN ]]; then
        echo "$(empty_space)$BLOCK_BEFORE%{$gray240%}node v$(nvm_prompt_info)$BLOCK_AFTER"
    fi
}

function empty_space() {
    echo "%{$gray237%}    "
}

PROMPT='
$(current_dir)$(path_without_last_dir)$(git_print_details)$(nvm_info)
%{$gray240%} ~@  '

RPROMPT='%{$gray240%}%n%{$gray235%}.%{$gray240%}%*'
