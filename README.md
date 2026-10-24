# dot_files

My dotfiles: zsh, Helix, Alacritty, yazi, and the tools they need. macOS + Homebrew.

## Install

Install [Homebrew](https://brew.sh) first, then:

```sh
curl -fsSL https://raw.githubusercontent.com/bewa1t/dot_files/main/install.sh | sh
```

This clones the repo to `~/.dotfiles` (override with `DOT_DIR=...`) and runs:

1. `setup/symlinks.sh` – links the configs into place. A real file already at a
   target is moved to `<target>.backup`.
2. `setup/install.sh` – installs every tool from `checks/` that's missing.
3. `setup/helix-grammars.sh` – compiles the zsh grammar for Helix.
4. `setup/theme-sync.sh` – loads the LaunchAgent that switches Alacritty and
   Helix between Catppuccin latte/mocha with macOS light/dark mode.

Every step is safe to re-run, so the same command also updates a machine.

## Layout

| Path | What |
|---|---|
| `zshrc.zsh` | `~/.zshrc`: runs the checks, then sources each `setup/*.zsh` |
| `checks/` | One file per tool group. Each line is `tool <name> <default path> <install command>`. Missing tools print a warning on shell start. |
| `setup/*.zsh` | Shell setup, one file per tool. Each skips itself if its tool is missing. |
| `setup/*.sh` | The install steps above (run by hand or by `install.sh`). |
| `env/` | `~/.env`: local env vars and secrets. `*.sh` is git-ignored. |
| `aliases/` | `~/.aliases`: local aliases. `*.sh` is git-ignored. |
| `alacritty/`, `helix/`, `yazi/` | App configs, linked into `~/.config/` |
| `theme-sync/` | Light/dark theme switcher + its LaunchAgent template |
| `oh-my-zsh-custom/` | `$ZSH_CUSTOM` |

## Local-only files

`env/*.sh` and `aliases/*.sh` never get committed. Put machine-specific
settings there, e.g. `env/cpp_setup.sh` or `aliases/personal.sh`.

## Adding a tool

1. Add a `tool` line to a file in `checks/`.
2. If it needs shell setup, add `setup/<tool>.zsh` starting with
   `has <name> <default path> || return 0`, and source it from `zshrc.zsh`.
