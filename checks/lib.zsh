# has <name> <default path>
# True if <name> is on PATH or <default path> exists. Quiet; setup/*.zsh use
# it to skip their setup when the tool is missing (checks/ already warned).
has() {
    command -v "$1" >/dev/null 2>&1 || [[ -e "$2" ]]
}

# tool <name> <default path> <install command>
# Like has, but when missing: prints a warning and returns 1, or runs
# <install command> if DOT_INSTALL is set (see setup/install.sh).
tool() {
    has "$1" "$2" && return 0
    if [[ -n "$DOT_INSTALL" ]]; then
        echo "Installing $1: $3"
        eval "$3"
    else
        echo "Warning: $1 is not installed (not on PATH or at $2)." >&2
        return 1
    fi
}
