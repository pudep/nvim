-- Define statusline highlight groups by linking to TokyoNight semantic hl groups
local function set_statusline_colors()
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local bg = normal_hl.bg

  local function fg(name)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    return hl.fg
  end

  vim.api.nvim_set_hl(0, "SLFilename",  { fg = fg("@keyword"),        bg = bg, bold = true })
  vim.api.nvim_set_hl(0, "SLLsp",       { fg = fg("@function"),       bg = bg })
  vim.api.nvim_set_hl(0, "SLError",     { fg = fg("DiagnosticError"), bg = bg, bold = true })
  vim.api.nvim_set_hl(0, "SLWarn",      { fg = fg("DiagnosticWarn"),  bg = bg })
  vim.api.nvim_set_hl(0, "SLHint",      { fg = fg("DiagnosticHint"),  bg = bg })
  vim.api.nvim_set_hl(0, "SLInfo",      { fg = fg("DiagnosticInfo"),  bg = bg })
  vim.api.nvim_set_hl(0, "SLCursor",    { fg = fg("CursorLineNr"),    bg = bg })
  vim.api.nvim_set_hl(0, "SLDefault",   { fg = fg("Comment"),         bg = bg })
  vim.api.nvim_set_hl(0, "SLRecording", { fg = fg("DiagnosticError"), bg = bg, bold = true })
  vim.api.nvim_set_hl(0, "SLTime",      { fg = fg("@string"),         bg = bg })  -- Green → @string
end

set_statusline_colors()
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_statusline_colors,
})

-- Live clock: ticks every second via libuv timer (autocmds can't do sub-minute intervals)
local clock_timer = vim.uv.new_timer()
clock_timer:start(0, 1000, vim.schedule_wrap(function()
  vim.cmd("redrawstatus")
end))

-- Clean up the timer when Neovim exits so it doesn't leak
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if clock_timer and not clock_timer:is_closing() then
      clock_timer:stop()
      clock_timer:close()
    end
  end,
})

-- Get active LSP server names
_G.get_lsp_name = function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "None" end
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return table.concat(names, ",")
end

-- Get diagnostic counts (only shows items > 0)
_G.get_diagnostics = function()
  local s = vim.diagnostic.severity
  local e = #vim.diagnostic.get(0, { severity = s.ERROR })
  local w = #vim.diagnostic.get(0, { severity = s.WARN })
  local h = #vim.diagnostic.get(0, { severity = s.HINT })
  local i = #vim.diagnostic.get(0, { severity = s.INFO })

  local parts = {}
  if e > 0 then table.insert(parts, "%#SLError#E:" .. e) end
  if w > 0 then table.insert(parts, "%#SLWarn#W:"  .. w) end
  if h > 0 then table.insert(parts, "%#SLHint#H:"  .. h) end
  if i > 0 then table.insert(parts, "%#SLInfo#I:"  .. i) end

  if #parts == 0 then return "" end
  return "%#SLDefault#[ " .. table.concat(parts, " ") .. " %#SLDefault#]"
end

-- Current macro recording register
_G.get_macro_recording = function()
  local reg = vim.fn.reg_recording()
  if reg == "" then return "" end
  return "%#SLRecording#[Recording @" .. reg .. "]"
end

-- Force redraw on macro state changes
local macro_grp = vim.api.nvim_create_augroup("StatuslineMacroRefresh", { clear = true })
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
  group = macro_grp,
  callback = function() vim.cmd("redrawstatus") end,
})

-- Live time display
_G.get_time = function()
  return "%#SLTime# " .. os.date("%H:%M:%S") .. " "
end

-- Build the full statusline string
_G.build_statusline = function()
  local macro    = _G.get_macro_recording()
  local filename = "%#SLDefault#[%#SLFilename#%t%#SLDefault#]"
  local lsp      = "[%#SLLsp#LSP:" .. _G.get_lsp_name() .. "%#SLDefault#]"
  local diag     = _G.get_diagnostics()
  local time     = _G.get_time()

  local macro_str = macro ~= "" and (macro .. " ") or ""
  local diag_str  = diag  ~= "" and (" " .. diag)  or ""
  local cursor    = "%#SLCursor#%l:%c"

  --  LEFT: macro · filename · lsp · diagnostics
  -- RIGHT: cursor position · time
  return macro_str .. filename .. " " .. lsp .. diag_str
      .. "%=" .. cursor .. " " .. time
end

vim.o.statusline = "%!v:lua.build_statusline()"
