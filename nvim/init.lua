-- Neovim config. Plugins: built-in vim.pack (:lua vim.pack.update() to update).
-- LSP: built-in client; server settings in lsp/<name>.lua.
-- Everything else is in lua/config/, loaded in this order.
vim.g.mapleader = ' ' -- before any <leader> keymap
vim.g.maplocalleader = ' '

require('config.options')
require('config.keymaps')
require('config.plugins')
require('config.colorscheme')
require('config.lsp')
