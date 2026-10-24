# --- SDKMAN (lazy) ---
# Sourcing sdkman-init.sh costs ~0.12s; the candidate bins are just symlinks.
has sdk "$HOME/.sdkman" || return 0
export SDKMAN_DIR="$HOME/.sdkman"
for _sdk_candidate in "$SDKMAN_DIR"/candidates/*/current/bin(N/); do
    export PATH="$_sdk_candidate:$PATH"
done
unset _sdk_candidate
[[ -d "$SDKMAN_DIR/candidates/java/current" ]] && \
    export JAVA_HOME="$SDKMAN_DIR/candidates/java/current"
# `sdk` itself is a shell function, so it needs the real init script.
sdk() {
    unfunction sdk
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    sdk "$@"
}
