-- Always load these (shared LSP base config)
require("user.config.server.diagnostic")
vim.api.nvim_create_autocmd("BufReadPre", {
    once = true,
    callback = function()
        require("user.config.tools.lsp")
        require("user.config.server.map")
    end,
})

-- Load each server only when its filetype is opened
local ft_servers = {
    lua = "user.config.server.HighLevel.lua_ls",
    python = "user.config.server.HighLevel.pyright",
    c = "user.config.server.LowLevel.clang",
    cpp = "user.config.server.LowLevel.clang",
    rust = "user.config.server.LowLevel.rust_analyzer",
    json = "user.config.server.Utilities.jsonls",
    css = "user.config.server.Web.css_ls",
    scss = "user.config.server.Web.css_ls",
    html = "user.config.server.Web.html",
    typescript = "user.config.server.Web.ts_ls",
    javascript = "user.config.server.Web.ts_ls",
    go = "user.config.server.Web.gopls",
}

for ft, mod in pairs(ft_servers) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        once = true,
        callback = function()
            require(mod)
        end,
    })
end
