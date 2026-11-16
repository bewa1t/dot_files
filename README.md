# seoul256-rio

[seoul256](https://github.com/junegunn/seoul256.vim) dark and light themes for the [Rio](https://rioterm.com) terminal.

## Install

Copy the theme files to Rio's themes folder:

```sh
git clone https://github.com/bewa1t/seoul256-rio ~/.config/rio/themes
```

If `~/.config/rio/themes` already exists, copy `seoul256.toml` and `seoul256-light.toml` into it instead.

Then pick a theme in `~/.config/rio/config.toml`:

```toml
theme = "seoul256"
```

Or follow the macOS light/dark mode:

```toml
[adaptive-theme]
light = "seoul256-light"
dark = "seoul256"
```

## Colors

All colors come from the default color map of seoul256.vim (not the xterm
palette), so the terminal background matches Vim and Neovim with
`termguicolors` exactly:

| | dark | light |
|---|---|---|
| background | `#4B4B4B` (237) | `#E1E1E1` (253) |
| foreground | `#D9D9D9` (252) | `#616161` (239) |

- The 16 ANSI colors use the same seoul256 color numbers as the
  [ghostty](https://github.com/jcmorrow/seoul256-ghostty) and
  [kitty](https://github.com/ubmit/seoul256-kitty) ports.
- Selection and search use the colors of Vim's `Visual`, `Search` and
  `IncSearch` groups. Tab titles and split borders use `TabLine`,
  `TabLineSel` and `VertSplit`.
- The dim foreground is halfway between the foreground and the background.

## License

MIT. The colors are from seoul256.vim, Copyright (c) 2017 Junegunn Choi.
