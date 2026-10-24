export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

DOT_DIR="${${(%):-%x}:A:h}"

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
