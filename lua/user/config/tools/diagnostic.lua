-- local icons = {
--   Error = ' ',
--   Warn  = ' ',
--   Hint  = '󰌶 ',
--   Info  = ' ',
-- }
local icons = {
    Error = "● ",
    Warn  = "● ",
    Hint  = "● ",
    Info  = "● ",
}
-- 1. Apply icons to the gutter (Signs)
for type, icon in pairs(icons) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- 2. Configure the diagnostic display
vim.diagnostic.config({
  virtual_text = false, 
  underline = true,
  update_in_insert = false, 
  severity_sort = true,     
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",      
    header = "",            
    -- This function uses your icons table for the float prefix
    prefix = function(diagnostic)
      local level = vim.diagnostic.severity[diagnostic.severity]
      return icons[level:sub(1,1) .. level:sub(2):lower()] or "", "Diagnostic" .. level
    end,
  },
})

-- 3. Trigger float on CursorHold
-- Note: 'updatetime' (default 4000ms) controls the delay. 
-- Most users prefer 300-500ms for responsiveness.
vim.opt.updatetime = 0

vim.api.nvim_create_autocmd("CursorHold", {
  buffer = bufnr,
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter" },
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})
