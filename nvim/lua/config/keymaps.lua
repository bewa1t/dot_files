-- General keymaps. Plugin keymaps are in plugins.lua, LSP keymaps in lsp.lua.
local map = vim.keymap.set
map('n', '<Esc>', '<cmd>nohlsearch<CR>')
map('t', '<Esc><Esc>', '<C-\\><C-n>')
-- Ctrl+`: show/hide one terminal at the bottom; the shell keeps running while hidden
local TERM_HEIGHT = 15
local term_buf
map({ 'n', 't' }, '<C-`>', function()
  local win = term_buf and vim.fn.bufwinid(term_buf) or -1
  if win ~= -1 then return vim.api.nvim_win_hide(win) end
  vim.cmd('botright ' .. TERM_HEIGHT .. 'split')
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.api.nvim_win_set_buf(0, term_buf)
  else
    vim.cmd.terminal()
    term_buf = vim.api.nvim_get_current_buf()
  end
  vim.cmd.startinsert()
end, { desc = 'Toggle terminal' })
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
