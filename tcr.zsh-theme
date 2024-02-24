# prompt style and colors based on Steve Losh's Prose theme:
# https://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# https://briancarper.net/blog/570/git-info-in-your-zsh-prompt

export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('%F{blue}`basename $VIRTUAL_ENV`%f') '
}

PR_GIT_UPDATE=1

setopt prompt_subst

# print -P "git_prompt_info:  $(git_prompt_info)" 
# print -P "parse_git_dirty:  $(parse_git_dirty)" 
# print -P "git_remote_status:  $(git_remote_status)" 
# print -P "git_current_branch:  $(git_current_branch)" 
# print -P "git_commits_ahead:  $(git_commits_ahead)" 
# print -P "git_commits_behind:  $(git_commits_behind)" 
# print -P "git_prompt_ahead:  $(git_prompt_ahead)" 
# print -P "git_prompt_behind:  $(git_prompt_behind)" 
# print -P "git_prompt_remote:  $(git_prompt_remote)" 
# print -P "git_prompt_short_sha:  $(git_prompt_short_sha)" 
# print -P "git_prompt_long_sha:  $(git_prompt_long_sha)" 
# print -P "git_prompt_status:  $(git_prompt_status)" 
# print -P "git_current_user_name:  $(git_current_user_name)" 
# print -P "git_current_user_email:  $(git_current_user_email)" 
# print -P "git_repo_name:  $(git_repo_name)" 

autoload -U add-zsh-hook
autoload -Uz vcs_info

#use extended color palette if available
if [[ $terminfo[colors] -ge 256 ]]; then
    turquoise="%F{81}"
    orange="%F{166}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"

    fc004="%F{004}"

    gray235="%F{235}"
    gray240="%F{240}"
    gray250="%F{250}"
else
    turquoise="%F{cyan}"
    orange="%F{yellow}"
    purple="%F{magenta}"
    hotpink="%F{red}"
    limegreen="%F{green}"
fi

# print color palette, for debug
# for i in {0..255}; do
#     print -Pn "%K{$i}  %k%F{black}${(l:3::0:)i}%f "
#     (( (i + 2) % 6 )) || print
# done

# enable VCS systems you use
zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%f"
FMT_BRANCH="%{$turquoise%}%b%u%c${PR_RST} "
FMT_ACTION="%{$limegreen%}%a${PR_RST} "
FMT_UNSTAGED="%{$orange%}! "
FMT_STAGED="%{$limegreen%}! "

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""


function TCR_preexec {
    case "$2" in
        *git*)
            PR_GIT_UPDATE=1
            ;;
        *hub*)
            PR_GIT_UPDATE=1
            ;;
        *svn*)
            PR_GIT_UPDATE=1
            ;;
    esac
}
add-zsh-hook preexec TCR_preexec

function TCR_chpwd {
    PR_GIT_UPDATE=0
}
add-zsh-hook chpwd TCR_chpwd

function TCR_precmd {
    if [[ -n "$PR_GIT_UPDATE" ]] ; then
        # check for untracked files or updated submodules, since vcs_info doesn't
        if git ls-files --other --exclude-standard 2> /dev/null | grep -q "."; then
            PR_GIT_UPDATE=1
            FMT_BRANCH="%{$turquoise%}%b%u%c%{$hotpink%} ● ${PR_RST}"
        else
            FMT_BRANCH="%{$turquoise%}%b%u%c${PR_RST}"
        fi
        zstyle ':vcs_info:*:prompt:*' formats "${FMT_BRANCH} "

        vcs_info 'prompt'
        PR_GIT_UPDATE=
    fi
}
add-zsh-hook precmd TCR_precmd

# backup
# PROMPT=$'
# %{$gray240%}[ %? %{$gray240%}] %n %s %m %~ %D %? %T %/ %M
# %{$purple%}%n${PR_RST} @ %{$orange%}%m${PR_RST} in %{$limegreen%}%~${PR_RST} $vcs_info_msg_0_$(virtualenv_info)
# 💩 '

setopt PROMPT_SUBST

function path_without_last_dir() {
    local path="${PWD/#$HOME/~}"  # Replace the home directory path with ~
    echo "${path%/*}"  # Remove the last directory
}

function empty_space() {
    echo "  "
}


## finished (until..)
RPROMPT='$vcs_info_msg_0_$(virtualenv_info) | %{$gray240%}%n%{$gray235%}.%{$gray240%}%*'


PROMPT='
%{$orange%}%1~ %{$gray235%}[%{$gray240%}$(path_without_last_dir)%{$gray235%}]
%{$gray240%}$ '

# PROMPT+=' %# '

