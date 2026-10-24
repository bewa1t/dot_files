#!/bin/sh
# macOS: install + load the LaunchAgent that keeps Alacritty/Helix themes in
# sync with light/dark mode. The plist is a template, since launchd needs
# absolute paths. Safe to re-run.
[ "$(uname)" = Darwin ] || exit 0
DOT="$(cd "$(dirname "$0")/.." && pwd)"
AGENT="$HOME/Library/LaunchAgents/local.sync-theme.plist"
mkdir -p "$(dirname "$AGENT")"
launchctl bootout "gui/$(id -u)" "$AGENT" 2>/dev/null
rm -f "$AGENT"
sed -e "s|__DOT__|$DOT|g" -e "s|__HOME__|$HOME|g" \
    "$DOT/theme-sync/local.sync-theme.plist" > "$AGENT"
launchctl bootstrap "gui/$(id -u)" "$AGENT" && echo "loaded $AGENT"
