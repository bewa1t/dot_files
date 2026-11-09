# menu-bar: macOS only; switches the menu bar hiding option with external displays.
[[ $OSTYPE == darwin* ]] && tool menu-bar-sync "$HOME/.local/bin/menu-bar-sync" \
    'sh "$DOT_DIR/setup/menu-bar.sh"'
