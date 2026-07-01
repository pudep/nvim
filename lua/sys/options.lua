-- ================================================
-- Disable useless stuff
-- ================================================
vim.g.rust_recommended_style = 0
vim.g.go_recommended_style = 0
vim.g.python_recommended_style = 0
vim.g.zig_recommended_style = 0
vim.g.markdown_recommended_style = 0

-- Disable obsolete plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "matchit",
  "matchparen",
  "netrw",
  "netrwFileHandlers",
  "netrwPlugin",
  "netrwSettings",
  "rrhelper",
  "spellfile_plugin",
  "tar",
  "tarPlugin",
  "tutor_mode_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
-- ================================================
-- Disable useless providers
-- ================================================
vim.g.loaded_remote_plugins = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
-- ================================================
-- Leader and keymap
-- ================================================
-- global leader 
vim.g.mapleader = " "

-- gloabl alias
_G.map = vim.keymap.set

-- local leader
vim.g.maplocalleader = "\\"

-- custom leaders
vim.keymap.set("n", ";", "<Nop>", { noremap = true })
vim.keymap.set("n", "|", "<Nop>", { noremap = true })
vim.keymap.set("n", "=", "<Nop>", { noremap = true })
vim.keymap.set("n", ",", "<Nop>", { noremap = true })
-- ================================================
-- Core 
-- ================================================
vim.o.updatetime = 300
vim.o.ttimeoutlen = 0
vim.o.timeoutlen = 800
vim.o.swapfile = false
vim.o.confirm = true
-- ================================================
-- Indent related
-- ================================================
vim.o.startofline = false
vim.o.breakindent = true
vim.o.tabstop = 2 -- Changed from 4
vim.o.shiftwidth = 2 -- Changed from 4
vim.o.softtabstop = 2 -- Changed from 4
vim.o.expandtab = true -- Keeps this as spaces (not tabs)
-- disable accidental macro recording on q
vim.keymap.set("n", "q", "<nop>")
vim.keymap.set("n", "<M-t>", "<nop>")
vim.keymap.set("n", "<M-r>", function()
  if vim.fn.reg_recording() == "" then
    vim.api.nvim_feedkeys("q", "n", false)
  end
end)

-- Ctrl-c stops recording; otherwise falls back to normal Ctrl-c behavior
vim.keymap.set("n", "<M-t>", function()
  if vim.fn.reg_recording() ~= "" then
    vim.api.nvim_feedkeys("q", "n", false)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end
end)

vim.keymap.set({ "n", "v" }, "<End>", "g$")
vim.keymap.set("i", "<End>", "<C-o>g$")
vim.keymap.set("n", "k", "g<Up>")
vim.keymap.set("n", "j", "g<Down>")
vim.keymap.set("n", "<Up>", "g<Up>")
vim.keymap.set("n", "<Down>", "g<Down>")

vim.keymap.set("i", "<Up>", "g<Up>")
vim.keymap.set("i", "<Down>", "g<Down>")

vim.keymap.set("v", "k", "g<Up>")
vim.keymap.set("v", "j", "g<Down>")
vim.keymap.set("v", "<Up>", "g<Up>")
vim.keymap.set("v", "<Down>", "g<Down>")

vim.keymap.set("n", "<C-q>", "<nop>")
vim.keymap.set("n", "<C-q>", "<cmd>q<cr>")
-- ================================================
-- Ui related
-- ================================================
vim.o.linebreak = true
vim.o.cmdheight = 0
vim.o.showcmd = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.winborder = "single"
vim.o.winminheight = 0
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
vim.o.showtabline = 2
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.opt.fillchars:append({ eob = " " })
vim.o.laststatus = 3
-- ================================================
-- Keep Bells off
-- ================================================
vim.o.visualbell = false
vim.o.errorbells = false
-- ================================================
-- Keep syntax off
-- ================================================
vim.cmd("syntax off")
vim.g.syntax_on = nil
vim.opt.syntax = "off"
