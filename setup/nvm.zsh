# --- nvm (lazy) ---
# Sourcing nvm.sh costs ~0.7s, mostly `nvm use default` at load time.
# Put nvm's default node (`nvm alias default`) on PATH directly; nvm strips
# this entry itself when you later `nvm use` a different version.
has nvm "$HOME/.nvm/nvm.sh" || return 0
export NVM_DIR="$HOME/.nvm"
# The alias is a version or a prefix ("22.23.4", "v22", "22"): take the
# newest installed match. Named aliases ("lts/*", "node") fall back to the
# newest install. `nOn` sorts by version number, newest first.
_nvm_default=$(<"$NVM_DIR/alias/default" 2>/dev/null)
_nvm_default_bin=("$NVM_DIR"/versions/node/v${_nvm_default#v}*/bin(N/nOn[1]))
[[ -z "$_nvm_default_bin" ]] && _nvm_default_bin=("$NVM_DIR"/versions/node/*/bin(N/nOn[1]))
[[ -n "$_nvm_default_bin" ]] && export PATH="$_nvm_default_bin:$PATH"
unset _nvm_default _nvm_default_bin
# nvm is a shell function, so first use pulls in the real script.
nvm() {
    unfunction nvm
    source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
    nvm "$@"
}
