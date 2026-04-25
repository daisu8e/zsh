## Default shell configuration
#
# set prompt
#
autoload colors
colors
autoload -Uz vcs_info
setopt prompt_subst

case "${ZSH_COLOR_MODE}" in
    light|dark)
        ;;
    *)
        ZSH_COLOR_MODE=dark
        ;;
esac

case "${ZSH_COLOR_MODE}" in
    light)
        zsh_prompt_color=$'%{\e[38;2;208;255;29m\e[48;2;64;64;64m%}'
        zsh_prompt2_color=$'%{\e[38;2;0;0;0m\e[48;2;208;255;29m%}'
        zsh_sprompt_color=$'%{\e[38;2;0;0;0m\e[48;2;208;255;29m%}'
        zsh_host_color=$'%{\e[38;2;208;255;29m\e[48;2;64;64;64m%}'
        zsh_root_prompt_color=$'%{\e[38;2;208;255;29m\e[48;2;64;64;64m%}'
        zsh_git_branch_color=$'%{\e[38;2;208;255;29m\e[48;2;128;128;128m%}'
        zsh_xterm_lscolors=exfxcxdxbxegedabagacadah
        zsh_xterm_ls_colors='rs=0:fi=30:di=90:ln=37:so=90:pi=90:ex=38;2;208;255;29:bd=90:cd=90:su=38;2;208;255;29:sg=38;2;208;255;29:tw=90:ow=90'
        zsh_xterm_list_colors=('fi=30' 'di=90' 'ln=37' 'so=90' 'pi=90' 'ex=38;2;208;255;29' 'bd=90' 'cd=90' 'su=38;2;208;255;29' 'sg=38;2;208;255;29' 'tw=90' 'ow=90')
        zsh_cons25_lscolors=exfxcxdxbxegedabagacadah
        zsh_cons25_ls_colors='rs=0:fi=30:di=90:ln=37:so=90:pi=90:ex=38;2;208;255;29:bd=90:cd=90:su=38;2;208;255;29:sg=38;2;208;255;29:tw=90:ow=90'
        zsh_cons25_list_colors=('fi=30' 'di=90' 'ln=37' 'so=90' 'pi=90' 'ex=38;2;208;255;29' 'bd=90' 'cd=90' 'su=38;2;208;255;29' 'sg=38;2;208;255;29' 'tw=90' 'ow=90')
        zsh_jfbterm_lscolors=exfxcxdxbxegedabagacadah
        zsh_jfbterm_ls_colors='rs=0:fi=30:di=90:ln=37:so=90:pi=90:ex=38;2;208;255;29:bd=90:cd=90:su=38;2;208;255;29:sg=38;2;208;255;29:tw=90:ow=90'
        zsh_jfbterm_list_colors=('fi=30' 'di=90' 'ln=37' 'so=90' 'pi=90' 'ex=38;2;208;255;29' 'bd=90' 'cd=90' 'su=38;2;208;255;29' 'sg=38;2;208;255;29' 'tw=90' 'ow=90')
        ;;
    dark)
        zsh_prompt_color=$'%{\e[38;2;208;255;29m\e[48;2;64;64;64m%}'
        zsh_prompt2_color=$'%{\e[38;2;0;0;0m\e[48;2;208;255;29m%}'
        zsh_sprompt_color=$'%{\e[38;2;0;0;0m\e[48;2;208;255;29m%}'
        zsh_host_color=$'%{\e[38;2;208;255;29m\e[48;2;64;64;64m%}'
        zsh_root_prompt_color=$'%{\e[38;2;208;255;29m\e[48;2;64;64;64m%}'
        zsh_git_branch_color=$'%{\e[38;2;208;255;29m\e[48;2;128;128;128m%}'
        zsh_xterm_lscolors=exfxcxdxbxacadabafaggx
        zsh_xterm_ls_colors='di=34:ln=35:so=32:pi=33:ex=31:bd=30;42:cd=30;43:su=30;41:sg=30;45:tw=30;46:ow=36'
        zsh_xterm_list_colors=('di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34')
        zsh_cons25_lscolors=ExFxCxdxBxegedabagacad
        zsh_cons25_ls_colors='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
        zsh_cons25_list_colors=('di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34')
        zsh_jfbterm_lscolors=gxFxCxdxBxegedabagacad
        zsh_jfbterm_ls_colors='di=01;36:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
        zsh_jfbterm_list_colors=('di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34')
        ;;
esac

zstyle ':vcs_info:git:*' formats "${zsh_git_branch_color} %b %{${reset_color}%}"

case ${UID} in
    0)
        PROMPT="${zsh_host_color} $(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') %B${zsh_root_prompt_color}%~ %{${reset_color}%}%b"'${vcs_info_msg_0_}'" "
        PROMPT2="%B${zsh_prompt2_color}%_#%{${reset_color}%}%b "
        SPROMPT="%B${zsh_sprompt_color}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
        ;;
    *)
        PROMPT="${zsh_host_color} %~ %{${reset_color}%}"'${vcs_info_msg_0_}'" "
        PROMPT2="${zsh_prompt2_color}%_%%%{${reset_color}%} "
        SPROMPT="${zsh_sprompt_color}%r is correct? [n,y,a,e]:%{${reset_color}%} "
        [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && PROMPT="${zsh_host_color}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]')${PROMPT}"
        ;;
esac

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

## Keybind configuration
#
# vi like keybind
#
bindkey -v

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# reverse menu completion binded to Shift-Tab
#
bindkey "\e[Z" reverse-menu-complete


## Command history configuration
#
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data


## Completion configuration
#
fpath=(${HOME}/.zsh/completions ${fpath})
autoload -U compinit
compinit


## zsh editor
#
autoload zed


## Prediction configuration
#
#autoload predict-on
#predict-off


## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
    freebsd*|darwin*)
        alias ls="ls -G -w"
        ;;
    linux*)
        alias ls="ls --color"
        ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -al"

alias du="du -h"
alias df="df -h"

alias su="su -l"

alias vi="vim"


## terminal configuration
#
case "${TERM}" in
    screen)
        TERM=xterm
        ;;
esac

## generator
# https://geoff.greer.fm/lscolors/
case "${TERM}" in
    xterm|xterm-color|xterm-256color)
        export LSCOLORS=${zsh_xterm_lscolors}
        export LS_COLORS=${zsh_xterm_ls_colors}
        zstyle ':completion:*' list-colors "${zsh_xterm_list_colors[@]}"
        ;;
    kterm-color)
        stty erase '^H'
        export LSCOLORS=${zsh_xterm_lscolors}
        export LS_COLORS=${zsh_xterm_ls_colors}
        zstyle ':completion:*' list-colors "${zsh_xterm_list_colors[@]}"
        ;;
    kterm)
        stty erase '^H'
        ;;
    cons25)
        unset LANG
        export LSCOLORS=${zsh_cons25_lscolors}
        export LS_COLORS=${zsh_cons25_ls_colors}
        zstyle ':completion:*' list-colors "${zsh_cons25_list_colors[@]}"
        ;;
    jfbterm-color)
        export LSCOLORS=${zsh_jfbterm_lscolors}
        export LS_COLORS=${zsh_jfbterm_ls_colors}
        zstyle ':completion:*' list-colors "${zsh_jfbterm_list_colors[@]}"
        ;;
esac

# set terminal title including current directory
#
precmd() {
    vcs_info
    case "${TERM}" in
        xterm|xterm-color|xterm-256color|kterm|kterm-color)
            echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
            ;;
    esac
}
