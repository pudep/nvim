-- Termux Clipboard Integration
-- Place in your init.lua or a separate file like lua/termux-clipboard.lua

local function termux_copy(text)
  local handle = io.popen("termux-clipboard-set", "w")
  if handle then
    handle:write(text)
    handle:close()
    vim.notify("Copied to clipboard", vim.log.levels.INFO)
  else
    vim.notify("termux-clipboard-set failed", vim.log.levels.ERROR)
  end
end

local function termux_paste()
  local handle = io.popen("termux-clipboard-get")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result
  end
  return nil
end

-- <Leader>yc — Copy yanked register (") to Termux clipboard
vim.keymap.set("n", "<leader>yc", function()
  local text = vim.fn.getreg('"')
  if text == "" then
    vim.notify("Yank register is empty", vim.log.levels.WARN)
    return
  end
  termux_copy(text)
end, { desc = "Copy yank register to Termux clipboard" })

-- <Leader>yt — Copy visual selection directly to Termux clipboard
vim.keymap.set("v", "<leader>yt", function()
  -- Yank selection into " register first
  vim.cmd('normal! "zy')
  local text = vim.fn.getreg("z")
  termux_copy(text)
end, { desc = "Copy visual selection to Termux clipboard" })

-- <Leader>pc — Paste from Termux clipboard at cursor
vim.keymap.set("n", "<leader>pc", function()
  local text = termux_paste()
  if text and text ~= "" then
    -- Remove trailing newline added by termux-clipboard-get
    text = text:gsub("\n$", "")
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local new_line = line:sub(1, col + 1) .. text .. line:sub(col + 2)
    -- Handle multiline paste properly
    if text:find("\n") then
      local lines = vim.split(text, "\n", { plain = true })
      vim.api.nvim_put(lines, "c", true, true)
    else
      vim.api.nvim_put({ text }, "c", true, true)
    end
    vim.notify("Pasted from clipboard", vim.log.levels.INFO)
  else
    vim.notify("Termux clipboard is empty", vim.log.levels.WARN)
  end
end, { desc = "Paste from Termux clipboard" })
