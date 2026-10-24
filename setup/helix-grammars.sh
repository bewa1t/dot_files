#!/bin/sh
# Compile the zsh grammar kept in helix/grammars into Helix's user runtime.
DOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$DOT/helix/grammars/tree-sitter-zsh/src"
mkdir -p "$DOT/helix/runtime/grammars"
cc -shared -fPIC -O2 -I "$SRC" "$SRC/parser.c" "$SRC/scanner.c" \
    -o "$DOT/helix/runtime/grammars/zsh.so" && echo "built helix/runtime/grammars/zsh.so"
