-- diagnostics_panel.lua
-- ~/.config/nvim/lua/diagnostics_panel.lua
-- require("diagnostics_panel").setup()

local M = {}

local SEV = vim.diagnostic.severity

local SEV_HL = {
    [SEV.ERROR] = "DiagnosticError",
    [SEV.WARN]  = "DiagnosticWarn",
    [SEV.INFO]  = "DiagnosticInfo",
    [SEV.HINT]  = "DiagnosticHint",
}

-- ── highlights ─────────────────────────────────────────────────────────────

local function setup_highlights()
    vim.api.nvim_set_hl(0, "DiagPanelCurLine", { link = "Title",   default = true })
    vim.api.nvim_set_hl(0, "DiagPanelMeta",    { link = "Comment", default = true })
    vim.api.nvim_set_hl(0, "DiagPanelMsg",     { link = "Normal",  default = true })
end

-- ── build lines + extmarks ─────────────────────────────────────────────────
--
-- Each line-group occupies exactly (1 + N) real buffer lines:
--   row 0  ""           ← blank anchor; virtual text "⟩ line 42" sits here
--   row 1  "  ●  msg"
--   row 2  "  ●  msg"
--
-- Between groups: one blank separator line (no virt text).

local BULLET = "●"   -- U+25CF, 3 UTF-8 bytes

local function build(diags, cur_line)
    local by_lnum = {}
    local order   = {}
    for _, d in ipairs(diags) do
        local ln = d.lnum
        if not by_lnum[ln] then
            by_lnum[ln] = {}
            table.insert(order, ln)
        end
        table.insert(by_lnum[ln], d)
    end

    table.sort(order, function(a, b)
        if a == cur_line and b ~= cur_line then return true  end
        if b == cur_line and a ~= cur_line then return false end
        return a < b
    end)

    -- lines[]  : raw buffer text
    -- hls[]    : { row, col_s, col_e, grp }  — nvim_buf_add_highlight
    -- virts[]  : { row, virt_text = {{text, hl}, ...} } — extmark virt_text
    local lines = {}
    local hls   = {}
    local virts = {}

    local function hl(row, cs, ce, grp)
        table.insert(hls, { row = row, col_s = cs, col_e = ce, grp = grp })
    end

    if #order == 0 then
        table.insert(lines, "")
        table.insert(virts, { row = 0, virt_text = { { "  ✓  no diagnostics", "DiagPanelMeta" } } })
        return lines, hls, virts
    end

    for i, ln in ipairs(order) do
        local is_cur  = (ln == cur_line)
        local hdr_hl  = is_cur and "DiagPanelCurLine" or "Normal"
        local arrow   = is_cur and "› " or "  "
        local lbl     = arrow .. "line " .. tostring(ln + 1)

        -- Separator blank between groups
        if i > 1 then
            table.insert(lines, "")
        end

        -- Anchor row: blank line that carries the virtual heading
        local anchor = #lines
        table.insert(lines, "")
        table.insert(virts, {
            row       = anchor,
            virt_text = { { lbl, hdr_hl } },
        })

        -- Diagnostic rows
        for _, d in ipairs(by_lnum[ln]) do
            local msg    = d.message:gsub("\n", " ")
            local src    = d.source and ("[" .. d.source .. "]") or ""
            local prefix = "  " .. BULLET .. "  "
            local entry  = prefix .. msg .. (src ~= "" and ("  " .. src) or "")
            local erow   = #lines
            table.insert(lines, entry)

            hl(erow, 2, 2 + #BULLET,           SEV_HL[d.severity] or "Normal")
            hl(erow, #prefix, #prefix + #msg,   "DiagPanelMsg")
            if src ~= "" then
                hl(erow, #prefix + #msg + 2, #entry, "DiagPanelMeta")
            end
        end
    end

    return lines, hls, virts
end

-- ── panel state ────────────────────────────────────────────────────────────

local ns = vim.api.nvim_create_namespace("diag_panel")
local S  = { bufnr = nil, winid = nil, src_winid = nil, autocmd_id = nil }

local function is_open()
    return S.bufnr and vim.api.nvim_buf_is_valid(S.bufnr)
       and S.winid and vim.api.nvim_win_is_valid(S.winid)
end

local function render(diags, cur_line)
    local lines, hls, virts = build(diags, cur_line)

    vim.bo[S.bufnr].modifiable = true
    vim.api.nvim_buf_set_lines(S.bufnr, 0, -1, false, lines)
    vim.bo[S.bufnr].modifiable = false

    vim.api.nvim_buf_clear_namespace(S.bufnr, ns, 0, -1)

    for _, h in ipairs(hls) do
        vim.api.nvim_buf_add_highlight(S.bufnr, ns, h.grp, h.row, h.col_s, h.col_e)
    end

    for _, v in ipairs(virts) do
        vim.api.nvim_buf_set_extmark(S.bufnr, ns, v.row, 0, {
            virt_text          = v.virt_text,
            virt_text_pos      = "overlay",   -- replaces the blank line visually
            hl_mode            = "combine",
        })
    end
end

local function refresh()
    if not is_open() then return end
    if not S.src_winid or not vim.api.nvim_win_is_valid(S.src_winid) then return end
    local src_buf  = vim.api.nvim_win_get_buf(S.src_winid)
    local cur_line = vim.api.nvim_win_get_cursor(S.src_winid)[1] - 1
    local diags    = vim.diagnostic.get(src_buf)
    table.sort(diags, function(a, b)
        if a.lnum ~= b.lnum then return a.lnum < b.lnum end
        return a.severity < b.severity
    end)
    render(diags, cur_line)
end

local function close()
    if S.autocmd_id then
        pcall(vim.api.nvim_del_autocmd, S.autocmd_id)
        S.autocmd_id = nil
    end
    if S.winid and vim.api.nvim_win_is_valid(S.winid) then
        vim.api.nvim_win_close(S.winid, true)
    end
    if S.bufnr and vim.api.nvim_buf_is_valid(S.bufnr) then
        vim.api.nvim_buf_delete(S.bufnr, { force = true })
    end
    S.bufnr = nil; S.winid = nil; S.src_winid = nil
end

local function open(height)
    local src_win  = vim.api.nvim_get_current_win()
    local src_buf  = vim.api.nvim_get_current_buf()
    local cur_line = vim.api.nvim_win_get_cursor(src_win)[1] - 1

    S.src_winid = src_win

    local diags = vim.diagnostic.get(src_buf)
    table.sort(diags, function(a, b)
        if a.lnum ~= b.lnum then return a.lnum < b.lnum end
        return a.severity < b.severity
    end)

    S.bufnr = vim.api.nvim_create_buf(false, true)
    vim.bo[S.bufnr].buftype   = "nofile"
    vim.bo[S.bufnr].filetype  = "diagnostics_panel"
    vim.bo[S.bufnr].bufhidden = "wipe"
    vim.bo[S.bufnr].swapfile  = false

    render(diags, cur_line)

    vim.cmd("botright " .. height .. "split")
    S.winid = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(S.winid, S.bufnr)

    -- winbar is per-split and works with laststatus=3
    vim.wo[S.winid].winbar = "  󰨮  Diagnostic Panel"

    local wo = vim.wo[S.winid]
    wo.number         = false
    wo.relativenumber = false
    wo.signcolumn     = "no"
    wo.wrap           = false
    wo.cursorline     = false
    wo.foldcolumn     = "0"
    wo.winfixheight   = true

    local km = function(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, { buffer = S.bufnr, silent = true })
    end
    km("q",     close)
    km("<Esc>", close)

    S.autocmd_id = vim.api.nvim_create_autocmd({ "CursorMoved", "DiagnosticChanged" }, {
        buffer   = src_buf,
        callback = refresh,
    })
    vim.api.nvim_create_autocmd("WinClosed", {
        pattern  = tostring(src_win),
        once     = true,
        callback = close,
    })

    vim.api.nvim_set_current_win(src_win)
end

-- ── setup ──────────────────────────────────────────────────────────────────

function M.setup(opts)
    opts = opts or {}
    local height = opts.height or 10

    setup_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_highlights })

    vim.keymap.set("n", opts.keymap or "<End>", function()
        if is_open() then close() else open(height) end
    end, { silent = true, desc = "Toggle Diagnostic Panel" })

    vim.keymap.set("n", opts.keymap_workspace or "<S-End>", function()
        vim.notify(
            "Workspace diagnostics not supported. Use Trouble.nvim for a project-wide view.",
            vim.log.levels.INFO,
            { title = "Diagnostic Panel" }
        )
    end, { silent = true, desc = "Workspace diagnostics (unavailable)" })
end

return M

