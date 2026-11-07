# fonts: iM Writing Nerd Font (iA Writer); configs use the "iMWritingMono Nerd Font" family.
if [[ "$OSTYPE" == darwin* ]]; then
    tool "iMWritingMono Nerd Font" "$HOME/Library/Fonts/iMWritingMonoNerdFont-Regular.ttf" \
        'brew install --cask font-im-writing-nerd-font'
else
    tool "iMWritingMono Nerd Font" "$HOME/.local/share/fonts/iA-Writer/iMWritingMonoNerdFont-Regular.ttf" \
        'mkdir -p ~/.local/share/fonts/iA-Writer &&
         curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/iA-Writer.tar.xz | tar -xJ -C ~/.local/share/fonts/iA-Writer &&
         fc-cache -f'
fi
