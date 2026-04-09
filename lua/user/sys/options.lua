-- speed
vim.o.updatetime = 0
vim.o.timeoutlen = 100
vim.o.ttimeoutlen = 0
vim.o.lazyredraw = true
vim.o.swapfile = true
vim.o.confirm = true
vim.o.visualbell = false
vim.o.errorbells = false



-- Indentation & Formatting
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.smartindent = true
vim.o.textwidth = 0
vim.o.backspace = 'indent,eol,start'

-- Search
vim.o.incsearch = true
vim.o.hlsearch = true
-- Fold
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.lsp.foldexpr()'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')

-- Keymaps: Spelling
vim.keymap.set('n', '<leader>fw', function()
  local word = vim.fn.expand('<cword>')
  local suggestions = vim.fn.spellsuggest(word, 1)

  if #suggestions > 0 then
    vim.cmd('normal! ciw' .. suggestions[1])
    vim.cmd('stopinsert')
  else
    vim.notify('No spelling suggestions found', vim.log.levels.WARN)
  end
end, { desc = 'Fix spelling (first suggestion)' })

vim.keymap.set('n', '<C-x>s', 'z=', { desc = 'Spelling suggestions' })
