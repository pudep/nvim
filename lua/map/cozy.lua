vim.keymap.set('n', '<A-Up>', function()
  vim.diagnostic.jump({ count = -1, float = false })
end, { desc = 'Previous diagnostic' })

vim.keymap.set('n', '<A-Down>', function()
  vim.diagnostic.jump({ count = 1, float = false })
end, { desc = 'Next diagnostic' })
