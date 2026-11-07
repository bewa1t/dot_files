#!/bin/sh
# Link dot_files into place. Safe to re-run; a real file/dir already at the
# target is moved to <target>.backup first.
DOT="$(cd "$(dirname "$0")/.." && pwd)"

link() {
  src="$DOT/$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.backup" && echo "moved $dst to $dst.backup"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  echo "$dst -> $src"
}

link zshrc.zsh     ~/.zshrc
link env           ~/.env
link aliases       ~/.aliases
link wezterm.lua   ~/.wezterm.lua
link alacritty     ~/.config/alacritty
link rio           ~/.config/rio
link helix         ~/.config/helix
link yazi          ~/.config/yazi
link git           ~/.config/git
# only the file: ~/.config/herdr also holds herdr's sockets, logs and sessions
link herdr/config.toml ~/.config/herdr/config.toml
