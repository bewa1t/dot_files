# core: shell framework and JVM version manager.
tool oh-my-zsh "$HOME/.oh-my-zsh" \
    'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc'
tool sdk "$HOME/.sdkman" \
    'curl -fsSL "https://get.sdkman.io?rcupdate=false" | bash'
