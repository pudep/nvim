local M = {}

----------------------------------------------------------------------
-- Highlight setup: steal the `fg` from real theme groups, force bg=NONE
----------------------------------------------------------------------
local function fg_of(group)
  local ok, def = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
  if ok and def and def.fg then
    return string.format("#%06x", def.fg)
  end
  return nil
end

local function set_hl(name, source_group, extra)
  extra = extra or {}
  vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", {
    fg = fg_of(source_group),
    bg = "NONE",
  }, extra))
end

local function build_highlights()
  set_hl("StlMode",       "Function",        { bold = true })
  set_hl("StlFile",        "Directory")
  set_hl("StlModified",    "Number")
  set_hl("StlRecording",   "DiagnosticError", { bold = true })
  set_hl("StlLsp",         "Special")
  set_hl("StlDiagError",   "DiagnosticError")
  set_hl("StlDiagWarn",    "DiagnosticWarn")
  set_hl("StlDiagInfo",    "DiagnosticInfo")
  set_hl("StlDiagHint",    "DiagnosticHint")
  set_hl("StlCursor",      "Comment")
end

----------------------------------------------------------------------
-- Mode aliases
----------------------------------------------------------------------
local modes = {
  n = "N", no = "N", nov = "N", noV = "N",
  i = "I", ic = "I", ix = "I",
  v = "V", V = "VL", [""] = "VB",
  R = "R", Rv = "R",
  c = "C", cv = "EX",
  t = "T", s = "S", S = "SL",
}

local function mode_text()
  local m = vim.fn.mode()
  return modes[m] or m:upper()
end

----------------------------------------------------------------------
-- Segments
----------------------------------------------------------------------
local function filename()
  local name = vim.fn.expand("%:t")
  if name == "" then name = "[No Name]" end
  local mod = vim.bo.modified and " ●" or ""
  return name .. "%#StlModified#" .. mod
end

local function recording()
  local reg = vim.fn.reg_recording()
  if reg == "" then return "" end
  return "%#StlRecording# REC@" .. reg
end

local function lsp_count()
  local n = #vim.lsp.get_clients({ bufnr = 0 })
  return "%#StlLsp# LSP " .. n
end

local function diagnostics()
  local diags = vim.diagnostic.get(0)
  local counts = {}
  for _, dg in ipairs(diags) do
    counts[dg.severity] = (counts[dg.severity] or 0) + 1
  end

  local e = counts[vim.diagnostic.severity.ERROR] or 0
  local w = counts[vim.diagnostic.severity.WARN] or 0
  local i = counts[vim.diagnostic.severity.INFO] or 0
  local h = counts[vim.diagnostic.severity.HINT] or 0

  local parts = {}
  if e > 0 then parts[#parts+1] = "%#StlDiagError# E:" .. e end  -- error
  if w > 0 then parts[#parts+1] = "%#StlDiagWarn# W:" .. w end   -- warn
  if i > 0 then parts[#parts+1] = "%#StlDiagInfo# I:" .. i end   -- info
  if h > 0 then parts[#parts+1] = "%#StlDiagHint#➤ H:" .. h end  -- hint

  if #parts == 0 then return "%#StlDiagHint#OK" end
  return table.concat(parts, "  ")
end

local function cursor_pos()
  return "%#StlCursor# %l:%c"
end

----------------------------------------------------------------------
-- Assemble
----------------------------------------------------------------------
function M.statusline()
  local rec = recording()

  return table.concat({
    "%#StlMode#" .. mode_text(),
    "   ",
    "%#StlFile#" .. filename(),
    rec ~= "" and ("    " .. rec) or "",
    "%=",                          -- right-align everything after this
    lsp_count(),
    "    ",
    diagnostics(),
    "    ",
    cursor_pos(),
    " ",
  })
end

----------------------------------------------------------------------
-- Public setup
----------------------------------------------------------------------
function M.setup()
  vim.o.laststatus = 3
  build_highlights()
  vim.o.statusline = "%!v:lua.require'ui.statusline'.statusline()"

  local group = vim.api.nvim_create_augroup("CustomStatusline", { clear = true })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = build_highlights,
  })

  vim.api.nvim_create_autocmd(
    { "RecordingEnter", "RecordingLeave", "LspAttach", "LspDetach", "DiagnosticChanged" },
    {
      group = group,
      callback = function() vim.cmd("redrawstatus") end,
    }
  )
end
return M
