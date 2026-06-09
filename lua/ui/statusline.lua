_G.lsp_status = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then return "" end

    local names = {}
    for _, c in ipairs(clients) do
        table.insert(names, c.name)
    end

    local e = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local w = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local h = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    local i = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

    local diag = ""
    if e > 0 then diag = diag .. " 󰅚 " .. e end
    if w > 0 then diag = diag .. " 󰀪 " .. w end
    if h > 0 then diag = diag .. " 󰌶 " .. h end
    if i > 0 then diag = diag .. "  " .. i end

    return "󰒋 " .. table.concat(names, ", ") .. diag
end

local function get_path_prefixes()
    local home = vim.uv.os_homedir()
    local prefixes = {}

    -- Manual high-priority entries first (most specific to least)
    local manual = {
        { home .. "/.config/nvim", "󰒋 nvim" },
        { home .. "/.config",      "󰒓 cfg" },
        { home,                    "󰋜 ~" },
    }
    for _, p in ipairs(manual) do
        table.insert(prefixes, p)
    end

    -- Pull all env vars that look like absolute paths
    local env = vim.fn.environ()  -- returns a dict of all env vars
    for name, val in pairs(env) do
        if val:sub(1, 1) == "/" and not val:find(":") then  -- skip PATH-style colon lists
            table.insert(prefixes, { val, "$" .. name })
        end
    end

    -- Sort longest path first so more specific paths match before broader ones
    table.sort(prefixes, function(a, b) return #a[1] > #b[1] end)

    return prefixes
end

_G.sl_filepath = function()
    local path = vim.fn.expand("%:p")
    if path == "" then return "󰈔 [No Name]" end

    local home = vim.uv.os_homedir()

    -- Home dir first (most common, cleanest display)
    if path:sub(1, #home) == home then
        return "󰈔 ~" .. path:sub(#home + 1)
    end

    -- Check env vars (longest match wins, already sorted by get_path_prefixes)
    local prefixes = get_path_prefixes()
    for _, pair in ipairs(prefixes) do
        local prefix, label = pair[1], pair[2]
        -- Skip the home/config entries we already handle above
        if prefix:sub(1, #home) ~= home then
            if path:sub(1, #prefix) == prefix then
                -- Strip the icon from label, keep just the $VAR name
                local var = label:match("%$%S+") or label
                return "󰈔 " .. var .. path:sub(#prefix + 1)
            end
        end
    end

    -- Fallback: absolute path as-is
    return "󰈔 " .. path
end

vim.opt.statusline = table.concat({
    " %{%v:lua.sl_filepath()%}",
    " %m%r",
    "%=",
    "%{%v:lua.lsp_status()%}",
    "  %l,%c  󰉸 %P ",
})
