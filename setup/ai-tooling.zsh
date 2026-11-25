# --- ai-tooling (optional extras, no warning when absent) ---
# LM Studio CLI (lms)
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"
# Claude Code: show the terminal's own cursor (thin bar) instead of its drawn block
export CLAUDE_CODE_NATIVE_CURSOR=1
# Claude Code: force session persistence
export CLAUDE_CODE_FORCE_SESSION_PERSISTENCE=1
