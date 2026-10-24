# --- nvm (lazy) ---
# Sourcing nvm.sh costs ~0.7s, mostly `nvm use default` at load time.
# Put the newest installed node's bin on PATH directly; nvm strips this
# entry itself when you later `nvm use` a different version.
has nvm "$HOME/.nvm/nvm.sh" || return 0
export NVM_DIR="$HOME/.nvm"
_nvm_default_bin=("$NVM_DIR"/versions/node/*/bin(N/on[1]))
[[ -n "$_nvm_default_bin" ]] && export PATH="$_nvm_default_bin:$PATH"
unset _nvm_default_bin
# nvm is a shell function, so first use pulls in the real script.
nvm() {
    unfunction nvm
    source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    nvm "$@"
}
