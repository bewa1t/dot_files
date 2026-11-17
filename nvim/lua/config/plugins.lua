-- Treesitter is built in (lua, vim, vimdoc, markdown); other languages use
-- Vim's regex syntax files.
local function gh(repo) return 'https://github.com/' .. repo end
vim.pack.add({
  gh('junegunn/seoul256.vim'),
  gh('ibhagwan/fzf-lua'),
  gh('nvim-mini/mini.nvim'),
  gh('MeanderingProgrammer/render-markdown.nvim'),
}, { confirm = false })

-- fzf-lua: .gitignore respected, no hidden or compressed files, no icons
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
  vim.keymap.set('n', '<leader>' .. key, '<cmd>FzfLua ' .. cmd .. '<CR>', { desc = cmd })
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
