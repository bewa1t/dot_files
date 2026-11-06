# --- Fresh: default editor (overrides helix.zsh when both are installed) ---
has fresh /opt/homebrew/bin/fresh || return 0
export EDITOR=fresh
export VISUAL=fresh
alias frx=fresh
