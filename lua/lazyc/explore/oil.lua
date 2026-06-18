-- lua/config/oil.lua
local function setup_oil()
  require("oil").setup({
    lsp_file_methods = {
      enabled = false,
    },
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
  })
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.defer_fn(setup_oil, 50)
  end,
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
