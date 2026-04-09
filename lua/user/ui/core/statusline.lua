vim.o.showcmdloc = "statusline"
vim.o.cmdheight=0

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then return "" end
  local names = {}
  for _, c in ipairs(clients) do
    table.insert(names, c.name)
  end
  return " [" .. table.concat(names, ", ") .. "]"
end

vim.o.statusline = "%!v:lua.Statusline()"

function _G.Statusline()
  local path = "%F"
  local modified = "%m"
  local readonly = "%r"
  local sep = "%="
  local showcmd = "%S"        -- pending command/count/macro
  local coords = "%l,%c"
  local percent = "%p%%"
  local lsp = lsp_clients()

  return path .. modified .. readonly .. sep .. showcmd .. "  " .. lsp .. "  " .. coords .. "  " .. percent .. " "
end
