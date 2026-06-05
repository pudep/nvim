vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "●",
            [vim.diagnostic.severity.WARN]  = "●",
            [vim.diagnostic.severity.INFO]  = "●",
            [vim.diagnostic.severity.HINT]  = "●",
        },
    },
    virtual_text = false,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        source = "always",
        header = "",
        prefix = "",
    },
})

local function lsp_hover_visible()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(winid).relative ~= "" then
            local ft = vim.bo[vim.api.nvim_win_get_buf(winid)].filetype
            if ft == "markdown" then return true end
        end
    end
    return false
end

local diagnostic_float_enabled = false

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = args.buf,
            callback = function()
                if not diagnostic_float_enabled or lsp_hover_visible() then return end
                vim.diagnostic.open_float(nil, {
                    focusable = false,
                    close_events = { "CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter" },
                })
            end,
        })
    end,
})

vim.keymap.set("n", "H", function()
    diagnostic_float_enabled = not diagnostic_float_enabled
    vim.notify(
        "Diagnostic float " .. (diagnostic_float_enabled and "enabled" or "disabled"),
        vim.log.levels.INFO
    )

    -- Instantly show float on enable, don't wait for CursorHold
    if diagnostic_float_enabled and not lsp_hover_visible() then
        vim.diagnostic.open_float(nil, {
            focusable = false,
            close_events = { "CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter" },
        })
    end
end, { desc = "Toggle diagnostic float popup" })

vim.api.nvim_create_user_command("DiagYankWhole", function()
    local diags = vim.diagnostic.get(0)
    if vim.tbl_isempty(diags) then
        print("No diagnostics in buffer")
        return
    end

    local lines = {}
    for _, d in ipairs(diags) do
        table.insert(lines, ("%s (%d:%d): %s"):format(
            d.source or "LSP", d.lnum + 1, d.col + 1, d.message
        ))
    end

    vim.fn.setreg('"', table.concat(lines, "\n"))
    print("Buffer diagnostics yanked")
end, {})

vim.api.nvim_create_user_command("DiagYankWorkspace", function()
    local lines = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) then
            local name = vim.api.nvim_buf_get_name(buf)
            for _, d in ipairs(vim.diagnostic.get(buf)) do
                table.insert(lines, ("%s:%d:%d [%s] %s"):format(
                    name ~= "" and name or "[No Name]",
                    d.lnum + 1, d.col + 1, d.source or "LSP", d.message
                ))
            end
        end
    end

    if #lines == 0 then
        print("No diagnostics in workspace")
        return
    end

    vim.fn.setreg('"', table.concat(lines, "\n"))
    print("Workspace diagnostics yanked")
end, {})
