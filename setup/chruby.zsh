# --- chruby / ruby (lazy) ---
# chruby.sh + auto.sh + `chruby ruby-3.4.1` costs ~0.08s. Deferred until a ruby
# command is actually used; the first call loads chruby, enables the .ruby-version
# auto-switch hook, selects the default ruby, then runs what you asked for.
has chruby /opt/homebrew/opt/chruby/share/chruby/chruby.sh || return 0
CHRUBY_DEFAULT_RUBY="ruby-3.4.1"
_load_chruby() {
    unfunction chruby ruby gem bundle bundler rake irb 2>/dev/null
    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    source /opt/homebrew/opt/chruby/share/chruby/auto.sh
    chruby "$CHRUBY_DEFAULT_RUBY"
    chruby_auto  # honor a .ruby-version in the current directory
}
for _ruby_cmd in chruby ruby gem bundle bundler rake irb; do
    eval "${_ruby_cmd}() { _load_chruby; ${_ruby_cmd} \"\$@\"; }"
done
unset _ruby_cmd
