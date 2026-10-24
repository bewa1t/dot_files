-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 140
config.initial_rows = 40

-- or, changing the font size and color scheme.
config.font_size = 15
config.font = wezterm.font 'JetBrains Mono'

-- Follow the macOS light/dark setting (re-evaluated when it changes)
local appearance = wezterm.gui and wezterm.gui.get_appearance() or 'Dark'
config.color_scheme = appearance:find 'Dark' and 'Catppuccin Mocha' or 'Catppuccin Latte'

-- The Catppuccin schemes already define tab colors; only the retro tab bar uses them
config.use_fancy_tab_bar = false

-- Finally, return the configuration to wezterm:
return config
