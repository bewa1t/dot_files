-- Neovim config. Plugins: built-in vim.pack (:lua vim.pack.update() to update).
-- LSP: built-in client; server settings in lsp/<name>.lua.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options
local o = vim.opt
local TAB = 4
o.expandtab = true
o.shiftwidth = TAB
o.tabstop = TAB
o.softtabstop = TAB
o.smartindent = true
o.breakindent = true
o.number = true
o.relativenumber = true
o.numberwidth = 1
o.signcolumn = 'yes'
o.cursorline = true
o.cursorcolumn = true
o.guicursor:append({ 't:ver25', 'v:hor20' }) -- underline in visual mode
o.laststatus = 3
o.statusline = ' %f %m%r%=%y %l:%c '
o.clipboard = 'unnamedplus'
o.mouse = 'a'
o.splitbelow = true
o.splitright = true
o.undofile = true
o.writebackup = false
o.updatetime = 100
o.ignorecase = true
o.smartcase = true
o.completeopt = { 'menuone', 'noselect', 'popup' }

-- Indent guides: a bar at each indent level of the buffer's shiftwidth
o.list = true
o.listchars = { tab = '│ ', nbsp = '+' }
local function indent_guides()
  vim.opt_local.listchars:append({ leadmultispace = '│' .. string.rep(' ', vim.fn.shiftwidth() - 1) })
end
vim.api.nvim_create_autocmd('BufWinEnter', { callback = indent_guides })
vim.api.nvim_create_autocmd('OptionSet', { pattern = { 'shiftwidth', 'tabstop' }, callback = indent_guides })

-- Keymaps
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

-- Plugins. Treesitter is built in (lua, vim, vimdoc, markdown); other languages
-- use Vim's regex syntax files.
local function gh(repo) return 'https://github.com/' .. repo end
vim.pack.add({
  gh('junegunn/seoul256.vim'),
  gh('ibhagwan/fzf-lua'),
  gh('nvim-mini/mini.nvim'),
  gh('MeanderingProgrammer/render-markdown.nvim'),
}, { confirm = false })

-- seoul256 follows 'background' when Nvim reloads it after a light/dark change.
-- Load it on VimEnter: seoul256 sets 'background' from Vim script, and Nvim stops
-- the live light/dark updates if that happens before its own VimEnter check.
vim.api.nvim_create_autocmd('VimEnter', { nested = true, callback = function()
  vim.cmd.colorscheme(vim.o.background == 'light' and 'seoul256-light' or 'seoul256')
end })

-- .gitignore respected, no hidden or compressed files, no icons
local no_icons = { file_icons = false, git_icons = false }
require('fzf-lua').setup({
  files = vim.tbl_extend('force', no_icons, {
    hidden = false,
    rg_opts = [[--color=never --files -g "!.git" -g "!*.{zip,gz,bz2,zst,lzo,sz,tgz,tbz2,lz,lz4,lzma,z,Z,xz,7z,rar,cab}"]],
  }),
  grep = no_icons,
})
for key, cmd in pairs({
  f = 'files', ['/'] = 'live_grep', b = 'buffers', j = 'jumps', ["'"] = 'resume',
  s = 'lsp_document_symbols', S = 'lsp_live_workspace_symbols',
  d = 'diagnostics_document', D = 'diagnostics_workspace',
}) do
  map('n', '<leader>' .. key, '<cmd>FzfLua ' .. cmd .. '<CR>', { desc = cmd })
end

require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.diff').setup({ view = { style = 'sign', signs = { add = '▍', change = '▍', delete = '▁' } } })
local clue = require('mini.clue')
clue.setup({
  triggers = {
    { mode = 'n', keys = '<Leader>' }, { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = 'g' }, { mode = 'x', keys = 'g' },
    { mode = 'n', keys = '[' }, { mode = 'n', keys = ']' },
  },
  clues = { clue.gen_clues.g() },
  window = { delay = 0 },
})
require('render-markdown').setup({ heading = { sign = false } })

-- LSP
vim.lsp.config('sourcekit', {
  cmd = { 'sourcekit-lsp' },
  filetypes = { 'swift' },
  -- buildServer.json first, so app and package files share one workspace
  root_markers = { 'buildServer.json', 'Package.swift', '.git' },
})
vim.lsp.enable('sourcekit')
if vim.fn.executable('jdtls') == 1 then vim.lsp.enable('jdtls') end
vim.diagnostic.config({ virtual_text = true })

-- Completion opens after 2 word characters and 250 ms of no typing
local COMPLETE_MIN_CHARS, COMPLETE_DELAY_MS = 2, 250
local function complete_while_typing(buf)
  local timer = assert(vim.uv.new_timer())
  vim.api.nvim_create_autocmd('TextChangedI', { buffer = buf, callback = function()
    timer:stop()
    local word = vim.api.nvim_get_current_line():sub(1, vim.fn.col('.') - 1):match('[%w_]+$') or ''
    if vim.fn.pumvisible() == 1 or #word < COMPLETE_MIN_CHARS then return end
    timer:start(COMPLETE_DELAY_MS, 0, vim.schedule_wrap(function()
      if vim.api.nvim_get_current_buf() == buf and vim.fn.mode() == 'i' and vim.fn.pumvisible() == 0 then
        vim.lsp.completion.get()
      end
    end))
  end })
  vim.api.nvim_create_autocmd('BufWipeout', { buffer = buf, once = true, callback = function() timer:close() end })
end

vim.api.nvim_create_autocmd('LspAttach', { callback = function(ev)
  local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
  local function bmap(lhs, rhs, desc) map('n', lhs, rhs, { buffer = ev.buf, desc = desc, nowait = true }) end
  bmap('gd', vim.lsp.buf.definition, 'Goto definition')
  bmap('gy', vim.lsp.buf.type_definition, 'Goto type definition')
  bmap('gr', '<cmd>FzfLua lsp_references<CR>', 'Goto references')
  bmap('gi', '<cmd>FzfLua lsp_implementations<CR>', 'Goto implementation')
  bmap('<leader>k', vim.lsp.buf.hover, 'Hover')
  bmap('<leader>r', vim.lsp.buf.rename, 'Rename symbol')
  bmap('<leader>a', '<cmd>FzfLua lsp_code_actions<CR>', 'Code action')
  if client:supports_method('textDocument/completion') then
    vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    complete_while_typing(ev.buf)
  end
end })
