# runtimes: language version managers (initialized lazily in zshrc).
tool pyenv /opt/homebrew/bin/pyenv 'brew install pyenv'
tool nvm    "$HOME/.nvm/nvm.sh" \
    'curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE=/dev/null bash'
tool chruby /opt/homebrew/opt/chruby/share/chruby/chruby.sh 'brew install chruby'
