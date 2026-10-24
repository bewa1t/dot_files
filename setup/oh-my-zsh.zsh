# --- Oh My Zsh ---
# Path to your Oh My Zsh installation.
has oh-my-zsh "$HOME/.oh-my-zsh" || return 0
export ZSH="$HOME/.oh-my-zsh"

# Custom plugins/themes/aliases live in this repo
export ZSH_CUSTOM="$DOT_DIR/oh-my-zsh-custom"

ZSH_THEME="arrow"
DISABLE_AUTO_TITLE="true"
plugins=(git docker)

# Skip the completion-dir security audit (compaudit). It costs ~55ms on a
# cold cache and currently reports nothing; re-run `compaudit` by hand after
# adding a new completion source to confirm it's still clean.
ZSH_DISABLE_COMPFIX=true
# Don't check for oh-my-zsh updates at startup; run `omz update` when you want it.
zstyle ':omz:update' mode disabled

source $ZSH/oh-my-zsh.sh
