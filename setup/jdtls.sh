#!/bin/sh
# Eclipse JDT LS: clone the fork (if needed), build it with Java 25, and link the
# launcher utils/jdtls/jdtls as ~/.local/bin/jdtls. Safe to re-run (rebuilds).
set -e
DOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$HOME/projects/eclipse.jdt.ls"
JAVA25="$(ls -d "$HOME"/.sdkman/candidates/java/25* 2>/dev/null | tail -n 1)"
[ -n "$JAVA25" ] || { echo "Java 25 is required: sdk install java 25.0.3-tem" >&2; exit 1; }
[ -d "$SRC" ] || gh repo clone bewa1t/eclipse.jdt.ls "$SRC"
(cd "$SRC" && JAVA_HOME="$JAVA25" ./mvnw clean verify -U -DskipTests=true -q)
mkdir -p "$HOME/.local/bin"
ln -sf "$DOT/utils/jdtls/jdtls" "$HOME/.local/bin/jdtls"
echo "jdtls: $SRC/org.eclipse.jdt.ls.product/target/repository -> $HOME/.local/bin/jdtls"
