#!/bin/sh
# Turn vim mode on or off in Zed and the agent CLIs (Claude Code, Codex, Pi).
# DOT_VIM_MODE picks it: 1 = on, 0 = off. zshrc.zsh sets it. Safe to re-run.
DOT="$(cd "$(dirname "$0")/.." && pwd)"
has() { command -v "$1" >/dev/null 2>&1 || [ -e "$2" ]; }

case "$DOT_VIM_MODE" in
  1) on=true  off=false claude=vim    ;;
  0) on=false off=true  claude=normal ;;
  *) echo "DOT_VIM_MODE must be 1 or 0, not '$DOT_VIM_MODE'" >&2; exit 1 ;;
esac

# Zed: zed/settings.json is ~/.config/zed/settings.json (JSON with comments, so sed, not jq)
f="$DOT/zed/settings.json"
if grep -q "\"vim_mode\": $off" "$f"; then
  sed -i '' "s/\"vim_mode\": $off/\"vim_mode\": $on/" "$f" && echo "zed: vim_mode $on"
fi

if has claude "$HOME/.local/bin/claude"; then
  f="$HOME/.claude/settings.json"
  mkdir -p "${f%/*}"; [ -s "$f" ] || echo '{}' > "$f"
  if [ "$(jq -r '.editorMode // "normal"' "$f")" != "$claude" ]; then
    jq --arg m "$claude" '.editorMode = $m' "$f" > "$f.tmp" && mv "$f.tmp" "$f" && echo "claude: editorMode $claude"
  fi
fi

if has codex /opt/homebrew/bin/codex; then
  f="$HOME/.codex/config.toml"
  mkdir -p "${f%/*}"; touch "$f"
  if ! grep -q "^vim_mode_default = $on\$" "$f"; then
    if grep -q '^vim_mode_default' "$f"; then
      sed -i '' "s/^vim_mode_default = .*/vim_mode_default = $on/" "$f"
    elif grep -q '^\[tui\]$' "$f"; then
      sed -i '' "s/^\[tui\]\$/&\\
vim_mode_default = $on/" "$f"
    else
      printf '\n[tui]\nvim_mode_default = %s\n' "$on" >> "$f"
    fi
    echo "codex: vim_mode_default $on"
  fi
fi

# Pi has no built-in vim mode; the modal editor extension adds a basic one (hjkl 0 $ x i a)
if has pi "$HOME/bin/pi"; then
  f="$HOME/.pi/agent/extensions/modal-editor.ts"
  if [ "$on" = true ] && [ ! -L "$f" ]; then
    mkdir -p "${f%/*}" && ln -sfn "$DOT/pi/modal-editor.ts" "$f" && echo "pi: modal editor linked"
  elif [ "$on" = false ] && [ -L "$f" ]; then
    rm "$f" && echo "pi: modal editor removed"
  fi
fi
