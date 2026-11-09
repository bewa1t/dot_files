#!/bin/sh
# macOS: build menu-bar-sync and load its LaunchAgent, which sets the menu bar
# hiding option whenever a display connects or disconnects. Safe to re-run.
[ "$(uname)" = Darwin ] || exit 0
DOT="$(cd "$(dirname "$0")/.." && pwd)"
BIN="$HOME/.local/bin/menu-bar-sync"
AGENT="$HOME/Library/LaunchAgents/local.menu-bar-sync.plist"
mkdir -p "$(dirname "$BIN")" "$(dirname "$AGENT")"
# Build beside the target and move it over, so a running copy is never overwritten.
/usr/bin/clang -O2 -Wall -Wextra -Werror -framework CoreFoundation -framework CoreGraphics -framework IOKit \
    -o "$BIN.new" "$DOT/utils/menu_bar/menu_bar.c" || exit 1
mv "$BIN.new" "$BIN"
launchctl bootout "gui/$(id -u)" "$AGENT" 2>/dev/null
rm -f "$AGENT"
sed "s|__HOME__|$HOME|g" "$DOT/utils/menu_bar/local.menu-bar-sync.plist" > "$AGENT"
launchctl bootstrap "gui/$(id -u)" "$AGENT" && echo "loaded $AGENT"
