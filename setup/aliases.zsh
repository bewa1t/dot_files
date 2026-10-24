# --- local aliases ---
# ~/.aliases -> dot_files/aliases. Its *.sh files are git-ignored, so each
# machine keeps its own aliases there (like ~/.env for env vars).
ALIASES_DIR="$HOME/.aliases"
if [ -d "$ALIASES_DIR" ]; then
  for alias_file in "$ALIASES_DIR"/*.sh(N); do
    source "$alias_file"
  done
  unset alias_file
else
  echo "WARNING: aliases dir $ALIASES_DIR not found, local aliases aren't set" >&2
fi
