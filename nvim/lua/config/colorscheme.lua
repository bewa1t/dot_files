-- seoul256 follows 'background' when Nvim reloads it after a light/dark change.
-- Load it on VimEnter: seoul256 sets 'background' from Vim script, and Nvim stops
-- the live light/dark updates if that happens before its own VimEnter check.
vim.api.nvim_create_autocmd('VimEnter', { nested = true, callback = function()
  vim.cmd.colorscheme(vim.o.background == 'light' and 'seoul256-light' or 'seoul256')
end })

-- Lighter light background: 255 (#F1F1F1), not the default 253. seoul256 reads
-- g:seoul256_background on every load, and its value also picks dark or light,
-- so set it for the current 'background' before each load.
-- Dark: 233 (darkest) to 239. Light: 252 to 256 (white).
local SEOUL256_DARK_BG, SEOUL256_LIGHT_BG = 237, 255
vim.api.nvim_create_autocmd('ColorSchemePre', { pattern = 'seoul256*', callback = function()
  vim.g.seoul256_background = vim.o.background == 'light' and SEOUL256_LIGHT_BG or SEOUL256_DARK_BG
end })
