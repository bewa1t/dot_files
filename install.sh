#!/bin/sh
# Bootstrap a machine from scratch:
#   curl -fsSL https://raw.githubusercontent.com/bewa1t/dot_files/main/install.sh | sh
# Safe to re-run: pulls the repo if it's already cloned, and every step skips
# what's already done. Set DOT_DIR to clone somewhere else.
set -e
REPO="https://github.com/bewa1t/dot_files.git"
DOT_DIR="${DOT_DIR:-$HOME/.dotfiles}"

if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
  echo "Homebrew is required first: https://brew.sh" >&2
  exit 1
fi
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -d "$DOT_DIR/.git" ]; then
  git -C "$DOT_DIR" pull --ff-only
else
  mkdir -p "$(dirname "$DOT_DIR")"
  git clone "$REPO" "$DOT_DIR"
fi

sh  "$DOT_DIR/setup/symlinks.sh"
zsh "$DOT_DIR/setup/install.sh"
sh  "$DOT_DIR/setup/helix-grammars.sh"
sh  "$DOT_DIR/setup/theme-sync.sh"

echo "Done. Open a new terminal to load the shell config."
