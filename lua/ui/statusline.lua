-- Define TokyoNight Moon color highlight groups
local function set_statusline_colors()
  local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
  local bg_color = statusline_hl.bg or "#222436"

  vim.api.nvim_set_hl(0, "SLFilename",  { fg = "#c099ff", bg = bg_color, bold = true }) -- Purple
  vim.api.nvim_set_hl(0, "SLLsp",       { fg = "#82a1ff", bg = bg_color })               -- Blue
  vim.api.nvim_set_hl(0, "SLError",     { fg = "#ff757f", bg = bg_color, bold = true }) -- Red
  vim.api.nvim_set_hl(0, "SLWarn",      { fg = "#ffc777", bg = bg_color })               -- Orange/Yellow
  vim.api.nvim_set_hl(0, "SLHint",      { fg = "#4fd6be", bg = bg_color })               -- Teal
  vim.api.nvim_set_hl(0, "SLInfo",      { fg = "#0db9d7", bg = bg_color })               -- Cyan
  vim.api.nvim_set_hl(0, "SLCursor",    { fg = "#c8d3f5", bg = bg_color })               -- Foreground Text
  vim.api.nvim_set_hl(0, "SLDefault",   { fg = "#a9b1d6", bg = bg_color })               -- Base Text
  vim.api.nvim_set_hl(0, "SLRecording", { fg = "#ff757f", bg = bg_color, bold = true }) -- Red Bold Macro
end

set_statusline_colors()
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_statusline_colors,
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

-- Get diagnostic counts dynamically (only shows items > 0)
_G.get_diagnostics = function()
  local s = vim.diagnostic.severity
  local e = #vim.diagnostic.get(0, { severity = s.ERROR })
  local w = #vim.diagnostic.get(0, { severity = s.WARN })
  local h = #vim.diagnostic.get(0, { severity = s.HINT })
  local i = #vim.diagnostic.get(0, { severity = s.INFO })

  local parts = {}
  if e > 0 then table.insert(parts, "%#SLError#E:" .. e) end
  if w > 0 then table.insert(parts, "%#SLWarn#W:" .. w) end
  if h > 0 then table.insert(parts, "%#SLHint#H:" .. h) end
  if i > 0 then table.insert(parts, "%#SLInfo#I:" .. i) end

  if #parts == 0 then return "" end
  
  return "%#SLDefault#[ " .. table.concat(parts, " ") .. " %#SLDefault#]"
end

-- Fetch current macro recording register status
_G.get_macro_recording = function()
  local recording_reg = vim.fn.reg_recording()
  if recording_reg == "" then return "" end
  return "%#SLRecording#[Recording @" .. recording_reg .. "]"
end

-- Instantly force statusline refresh when macro states shift
local macro_refresh_grp = vim.api.nvim_create_augroup("StatuslineMacroRefresh", { clear = true })
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
  group = macro_refresh_grp,
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

-- Combine elements into a single execution generator
_G.build_statusline = function()
  local macro = _G.get_macro_recording()
  local filename = "%#SLDefault#[%#SLFilename#%t%#SLDefault#]"
  local lsp = "[%#SLLsp#LSP:" .. _G.get_lsp_name() .. "%#SLDefault#]"
  local diag = _G.get_diagnostics()
  
  local macro_str = macro ~= "" and (macro .. " ") or ""
  local diag_str = diag ~= "" and (" " .. diag) or ""
  local cursor = "%= %#SLCursor#%l:%c "

  return macro_str .. filename .. " " .. lsp .. diag_str .. cursor
end

-- Execute the evaluation function directly for parsing highlights
vim.o.statusline = "%!v:lua.build_statusline()"
