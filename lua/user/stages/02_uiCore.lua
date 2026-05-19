-- ===========================
-- 02_uiCore
-- ===========================

-- Must be at startup (colorscheme/visuals needed before first render)

vim.schedule(function()
  -- Buffer/status UI: only once a buffer exists
  require('user.ui.core.cokeline')
  require('user.ui.core.statusline')
    require('user.ui.core.ibl')      -- indent lines
end)
