-- General keymaps. Plugin keymaps are in plugins.lua, LSP keymaps in lsp.lua.
local map = vim.keymap.set
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('t', '<Esc><Esc>', '<C-\\><C-n>')
for _, k in ipairs({ 'h', 'j', 'k', 'l' }) do map('n', '<C-' .. k .. '>', '<C-w><C-' .. k .. '>') end
map('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = 'Split vertical' })
map('n', '<leader>wh', '<cmd>split<CR>', { desc = 'Split horizontal' })
map('v', '<', '<gv')
map('v', '>', '>gv')
-- off: easy to hit by accident (0.13 uses Q for multiple cursors)
for _, k in ipairs({ 's', 'S', 'Z' }) do map('n', k, '<Nop>') end
if vim.fn.has('nvim-0.13') == 0 then map('n', 'Q', '<Nop>') end
map({ 'n', 'v', 'i' }, '<MiddleMouse>', '<Nop>')

-- space L: copy "/full/path:line" (or ":start-end" for a selection), symlinks resolved
map({ 'n', 'x' }, '<leader>L', function()
  local a, b = vim.fn.line('v'), vim.fn.line('.')
  local lines = a == b and a or math.min(a, b) .. '-' .. math.max(a, b)
  vim.fn.setreg('+', vim.fn.resolve(vim.fn.expand('%:p')) .. ':' .. lines)
  vim.api.nvim_echo({ { 'reference copied' } }, false, {})
end, { desc = 'Copy path:line' })
