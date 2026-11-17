-- Built-in LSP client. Server settings that need more than a few lines go in
-- lsp/<name>.lua at the config root.
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
  local function bmap(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc, nowait = true }) end
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
