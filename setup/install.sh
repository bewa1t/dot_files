#!/bin/zsh
# Install every tool from checks/ that isn't already installed. Safe to re-run.
DOT_DIR="${0:A:h:h}"
DOT_INSTALL=1
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
source "$DOT_DIR/checks/lib.zsh"
for _check in "$DOT_DIR"/checks/*.sh; do
    source "$_check"
done
# Fail if any install failed, so zshrc retries setup next shell
exit ${DOT_FAILED:-0}
