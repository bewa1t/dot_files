#!/bin/sh
# Turn on vim mode in the installed agent CLIs. Only sets it when the setting
# is missing, so a value you changed yourself is kept. Safe to re-run.
DOT="$(cd "$(dirname "$0")/.." && pwd)"
has() { command -v "$1" >/dev/null 2>&1 || [ -e "$2" ]; }

if has claude "$HOME/.local/bin/claude"; then
  f="$HOME/.claude/settings.json"
  mkdir -p "${f%/*}"; [ -s "$f" ] || echo '{}' > "$f"
  if [ "$(jq 'has("editorMode")' "$f")" = false ]; then
    jq '.editorMode = "vim"' "$f" > "$f.tmp" && mv "$f.tmp" "$f" && echo "claude: vim mode on"
  fi
fi

if has codex /opt/homebrew/bin/codex; then
  f="$HOME/.codex/config.toml"
  mkdir -p "${f%/*}"; touch "$f"
  if ! grep -q '^vim_mode_default' "$f"; then
    if grep -q '^\[tui\]' "$f"; then
      sed -i '' 's/^\[tui\]$/[tui]\
vim_mode_default = true/' "$f"
    else
      printf '\n[tui]\nvim_mode_default = true\n' >> "$f"
    fi
    echo "codex: vim mode on"
  fi
fi

# Pi has no built-in vim mode; load the modal editor extension (basic: hjkl 0 $ x i a)
if has pi "$HOME/bin/pi"; then
  mkdir -p "$HOME/.pi/agent/extensions"
  ln -sfn "$DOT/pi/modal-editor.ts" "$HOME/.pi/agent/extensions/modal-editor.ts"
  echo "pi: modal editor linked"
fi
