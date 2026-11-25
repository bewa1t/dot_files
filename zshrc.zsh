export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

DOT_DIR="${${(%):-%x}:A:h}"

# Vim mode in Zed, Claude Code, Codex and Pi: 1 = on, 0 = off.
# The next new shell applies a change (setup/ai-vim-mode.sh).
export DOT_VIM_MODE=0

# Run the setup/*.sh steps (links, installs, grammar, theme agent) by
# themselves: once per commit and DOT_VIM_MODE value, so again after a pull
# or a toggle, and again on the next shell if any step failed.
_stamp="$HOME/.local/state/dotfiles/setup-done"
# Read HEAD's commit from .git without starting git; fall back to git for
# packed refs and linked worktrees (where .git is a file).
_head=$(<"$DOT_DIR/.git/HEAD") 2>/dev/null
[[ $_head == "ref: "* ]] && _head=$(<"$DOT_DIR/.git/${_head#ref: }") 2>/dev/null
(( ${#_head} == 40 )) || _head="$(git -C "$DOT_DIR" rev-parse HEAD 2>/dev/null)"
_key="$_head vim=$DOT_VIM_MODE"
if [[ -n "$_head" && "$(<"$_stamp")" != "$_key" ]] 2>/dev/null; then
    echo "dotfiles: running setup for ${_head:0:7}"
    _failed=()
    for _step in \
        symlinks.sh \
        install.sh \
        theme-sync.sh \
        menu-bar.sh \
        ai-vim-mode.sh; do
        "$DOT_DIR/setup/$_step" || _failed+=("$_step")
    done
    if (( $#_failed )); then
        echo "dotfiles: failed: ${_failed[*]}; retrying next shell" >&2
    else
        mkdir -p "${_stamp:h}" && echo "$_key" > "$_stamp"
    fi
fi
unset _stamp _head _key _failed _step

# Local env vars first: checks read flags from them (e.g. ENABLE_JDTLS).
source "$DOT_DIR/setup/envs.zsh"

# Checks: warn about missing tools (setup/install.sh installs them).
source "$DOT_DIR/checks/lib.zsh"
for _check in "$DOT_DIR"/checks/*.sh; do
    source "$_check"
done
unset _check

# Setup: one file per tool, each skips itself if its tool is missing.
source "$DOT_DIR/setup/editor.zsh"
source "$DOT_DIR/setup/zsh.zsh"
source "$DOT_DIR/setup/sdkman.zsh"
source "$DOT_DIR/setup/nvm.zsh"
source "$DOT_DIR/setup/pyenv.zsh"
source "$DOT_DIR/setup/chruby.zsh"
source "$DOT_DIR/setup/ai-tooling.zsh"
source "$DOT_DIR/setup/aliases.zsh"
source "$DOT_DIR/setup/clock.zsh"
source "$DOT_DIR/setup/yazi.zsh"

