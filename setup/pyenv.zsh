# --- pyenv (lazy) ---
# `eval "$(pyenv init -)"` costs ~0.18s (subprocess + completion setup).
# The shims dir is all that python/pip need, so add it directly and defer
# the rest until `pyenv` itself is called (needed for `pyenv shell`).
has pyenv /opt/homebrew/bin/pyenv || return 0
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
[[ -d $PYENV_ROOT/shims ]] && export PATH="$PYENV_ROOT/shims:$PATH"
export PYENV_SHELL=zsh
pyenv() {
    unfunction pyenv
    eval "$(command pyenv init -)"
    pyenv "$@"
}
