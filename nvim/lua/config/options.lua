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
