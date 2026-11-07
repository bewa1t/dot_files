# --- zsh: completion, history, keys, prompt ---

# Completion. Brew's completions (_docker, _colima, _brew...) live here.
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit
# Trust the dump (-C: no rescan, no audit) unless it's over a day old, so new
# completions show up within a day. Delete ~/.zcompdump to pick them up now.
_zdump=${ZDOTDIR:-$HOME}/.zcompdump
_zfresh=( $_zdump(N.mh-24) )   # the dump, if modified in the last 24h
if (( $#_zfresh )); then
    compinit -C -d $_zdump
else
    compinit -i -d $_zdump && touch $_zdump
fi
unset _zdump _zfresh
setopt auto_menu complete_in_word always_to_end
unsetopt menu_complete flow_control
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# History
HISTFILE=~/.zsh_history HISTSIZE=50000 SAVEHIST=10000
setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space \
    hist_verify share_history

# Directories and misc
setopt auto_cd auto_pushd pushd_ignore_dups pushd_minus interactive_comments \
    multios long_list_jobs
alias -g ...='../..' ....='../../..'
alias -- -='cd -'
alias l='ls -lah' ll='ls -lh' la='ls -lAh' md='mkdir -p'
export CLICOLOR=1 LSCOLORS="exfxcxdxbxbxbxbxbxbxbx"
export PAGER=${PAGER:-less} LESS=${LESS:--R}

# Keys (emacs mode): up/down search history by what's typed so far.
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line \
    bracketed-paste-magic url-quote-magic
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line
zle -N bracketed-paste bracketed-paste-magic
zle -N self-insert url-quote-magic
for _k _w in \
    '^[[A' up-line-or-beginning-search   '^[OA' up-line-or-beginning-search \
    '^[[B' down-line-or-beginning-search '^[OB' down-line-or-beginning-search \
    '^[[H' beginning-of-line '^[OH' beginning-of-line \
    '^[[F' end-of-line       '^[OF' end-of-line \
    '^[[3~' delete-char '^[[3;5~' kill-word \
    '^[[1;5C' forward-word '^[[1;5D' backward-word \
    '^[[Z' reverse-menu-complete \
    '^r' history-incremental-search-backward \
    ' ' magic-space \
    '^x^e' edit-command-line; do
    bindkey "$_k" "$_w"
done
unset _k _w

# Prompt: yellow (red as root) dir ➤, git branch
# on the right with * when there are uncommitted or untracked changes.
_prompt_git() {
    local b
    b=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return
    [[ -n $(git status --porcelain --ignore-submodules=dirty 2>/dev/null | head -1) ]] && b+='*'
    print -rn -- "git:$b"
}
setopt prompt_subst
PROMPT='%(!.%F{red}.%F{yellow})%c ➤ %f'
RPROMPT='%(!.%F{red}.%F{yellow}) $(_prompt_git)%f'
