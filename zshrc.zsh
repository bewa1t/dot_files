export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

DOT_DIR="${${(%):-%x}:A:h}"

# Run the setup/*.sh steps (links, installs, grammar, theme agent) by
# themselves: once per commit, so again after a pull, and again on the next
# shell if any step failed.
_stamp="$HOME/.local/state/dotfiles/setup-done"
_head="$(git -C "$DOT_DIR" rev-parse HEAD 2>/dev/null)"
if [[ -n "$_head" && "$(cat "$_stamp" 2>/dev/null)" != "$_head" ]]; then
    echo "dotfiles: running setup for ${_head:0:7}"
    _failed=()
    for _step in symlinks.sh install.sh helix-grammars.sh theme-sync.sh ai-vim-mode.sh; do
        "$DOT_DIR/setup/$_step" || _failed+=("$_step")
    done
    if (( $#_failed )); then
        echo "dotfiles: failed: ${_failed[*]}; retrying next shell" >&2
    else
        mkdir -p "${_stamp:h}" && echo "$_head" > "$_stamp"
    fi
fi
unset _stamp _head _failed _step

# Checks: warn about missing tools (setup/install.sh installs them).
source "$DOT_DIR/checks/lib.zsh"
for _check in "$DOT_DIR"/checks/*.sh; do
    source "$_check"
done
unset _check

# Setup: one file per tool, each skips itself if its tool is missing.
source "$DOT_DIR/setup/envs.zsh"
source "$DOT_DIR/setup/helix.zsh"
source "$DOT_DIR/setup/oh-my-zsh.zsh"
source "$DOT_DIR/setup/sdkman.zsh"
source "$DOT_DIR/setup/nvm.zsh"
source "$DOT_DIR/setup/pyenv.zsh"
source "$DOT_DIR/setup/chruby.zsh"
source "$DOT_DIR/setup/ai-tooling.zsh"
source "$DOT_DIR/setup/aliases.zsh"
source "$DOT_DIR/setup/clock.zsh"
source "$DOT_DIR/setup/yazi.zsh"

