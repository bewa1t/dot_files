# --- local env vars ---
# ~/.env -> dot_files/env. Its *.sh files are git-ignored, so each machine
# keeps its own env vars and secrets there.
ENV_DIR="$HOME/.env"
if [ -d "$ENV_DIR" ]; then
  for env_file in "$ENV_DIR"/*.sh(N); do
    source "$env_file"
  done
  unset env_file
else
  echo "WARNING: envs dir $ENV_DIR not found, local env vars aren't set" >&2
fi
