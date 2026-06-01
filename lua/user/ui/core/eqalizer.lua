local M = {}

local function hl_fg(name)
    local hl = vim.api.nvim_get_hl(0, { name = name })
    return hl.fg and string.format('#%06x', hl.fg) or nil
end

local function hl_bg(name)
    local hl = vim.api.nvim_get_hl(0, { name = name })
    return hl.bg and string.format('#%06x', hl.bg) or nil
end

local function hl_get(name)
    return vim.api.nvim_get_hl(0, { name = name })
end

function M.setup()
    local bg       = hl_bg('Normal')
    local fg       = hl_fg('Normal')
    local border_fg =
        hl_fg('Special')
        or hl_fg('NonText')
        or hl_fg('Normal')
    local accent   = hl_fg('Special') or border_fg
    local muted    = hl_fg('Comment') or fg
    local sel_bg   = hl_bg('Visual')  or hl_bg('CursorLine') or bg
    local sel_fg   = hl_fg('Visual')  or fg
    local pmenu_bg = hl_bg('Pmenu')   or bg
    local pmenu_fg = hl_fg('Pmenu')   or fg
    local pmenu_sel_bg = hl_bg('PmenuSel') or sel_bg
    local pmenu_sel_fg = hl_fg('PmenuSel') or sel_fg
    local err_fg   = hl_fg('DiagnosticError') or hl_fg('ErrorMsg') or '#ff0000'
    local warn_fg  = hl_fg('DiagnosticWarn')  or hl_fg('WarningMsg') or '#ffaa00'
    local info_fg  = hl_fg('DiagnosticInfo')  or accent
    local hint_fg  = hl_fg('DiagnosticHint')  or muted
    local ok_fg    = hl_fg('DiagnosticOk')    or hl_fg('String') or '#00ff88'
    local added_fg = hl_fg('DiffAdd')  or hl_fg('diffAdded')  or ok_fg
    local deld_fg  = hl_fg('DiffDelete') or hl_fg('diffRemoved') or err_fg
    local chgd_fg  = hl_fg('DiffChange') or hl_fg('diffChanged') or warn_fg

    -- ─────────────────────────────────────────────────────────────
    -- Core floats / borders / splits  (original groups)
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'NormalFloat',  { bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'FloatTitle',   { fg = bg, bg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'FloatBorder',  { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'VertSplit',    { fg = border_fg, bold = true })

    vim.g.float_border_style = 'rounded'

    -- ─────────────────────────────────────────────────────────────
    -- blink.cmp  (completion menu)
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'BlinkCmpMenu',            { bg = pmenu_bg, fg = pmenu_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder',      { fg = border_fg, bg = pmenu_bg, bold = true })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection',   { bg = pmenu_sel_bg, fg = pmenu_sel_fg, bold = true })
    vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarThumb',  { bg = border_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpScrollBarGutter', { bg = pmenu_bg })
    vim.api.nvim_set_hl(0, 'BlinkCmpLabel',           { fg = pmenu_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch',      { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'BlinkCmpLabelDeprecated', { fg = muted, strikethrough = true })
    vim.api.nvim_set_hl(0, 'BlinkCmpKind',            { fg = accent })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindText',        { fg = pmenu_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindMethod',      { fg = accent })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindFunction',    { fg = accent })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindConstructor', { fg = accent })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindField',       { fg = info_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindVariable',    { fg = pmenu_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindClass',       { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindInterface',   { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindModule',      { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindProperty',    { fg = info_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindUnit',        { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindValue',       { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindEnum',        { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindKeyword',     { fg = accent })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindSnippet',     { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindColor',       { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindFile',        { fg = pmenu_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindReference',   { fg = info_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindFolder',      { fg = pmenu_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindEnumMember',  { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindConstant',    { fg = accent })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindStruct',      { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindEvent',       { fg = err_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindOperator',    { fg = accent })
    vim.api.nvim_set_hl(0, 'BlinkCmpKindTypeParameter', { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpDoc',             { bg = pmenu_bg, fg = pmenu_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder',       { fg = border_fg, bg = pmenu_bg, bold = true })
    vim.api.nvim_set_hl(0, 'BlinkCmpDocSeparator',    { fg = border_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp',   { bg = pmenu_bg, fg = pmenu_fg })
    vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { fg = border_fg, bg = pmenu_bg, bold = true })
    vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpActiveParameter', { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'BlinkCmpGhostText',       { fg = muted, italic = true })

    -- ─────────────────────────────────────────────────────────────
    -- dressing.nvim  (enhanced vim.ui.input / vim.ui.select)
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'DressingInput',        { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'DressingInputBorder',  { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'DressingSelect',       { bg = pmenu_bg, fg = pmenu_fg })
    vim.api.nvim_set_hl(0, 'DressingSelectBorder', { fg = border_fg, bg = pmenu_bg, bold = true })

    -- ─────────────────────────────────────────────────────────────
    -- fzf-lua
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'FzfLuaNormal',         { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'FzfLuaBorder',         { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaTitle',          { fg = bg, bg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaPreviewNormal',  { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'FzfLuaPreviewBorder',  { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaPreviewTitle',   { fg = bg, bg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaCursor',         { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaCursorLine',     { bg = sel_bg })
    vim.api.nvim_set_hl(0, 'FzfLuaCursorLineNr',   { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaSearch',         { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaScrollBorder',   { fg = border_fg })
    vim.api.nvim_set_hl(0, 'FzfLuaScrollFloat',    { fg = border_fg })
    vim.api.nvim_set_hl(0, 'FzfLuaHelpNormal',     { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'FzfLuaHelpBorder',     { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaHeaderBind',     { fg = accent })
    vim.api.nvim_set_hl(0, 'FzfLuaHeaderText',     { fg = muted })
    vim.api.nvim_set_hl(0, 'FzfLuaPathColNr',      { fg = info_fg })
    vim.api.nvim_set_hl(0, 'FzfLuaPathLineNr',     { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'FzfLuaBufName',        { fg = accent })
    vim.api.nvim_set_hl(0, 'FzfLuaBufNr',          { fg = muted })
    vim.api.nvim_set_hl(0, 'FzfLuaBufFlagCur',     { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaBufFlagAlt',     { fg = info_fg })
    vim.api.nvim_set_hl(0, 'FzfLuaTabTitle',       { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaTabMarker',      { fg = ok_fg, bold = true })
    vim.api.nvim_set_hl(0, 'FzfLuaDirIcon',        { fg = accent })
    vim.api.nvim_set_hl(0, 'FzfLuaFilePart',       { fg = fg })
    vim.api.nvim_set_hl(0, 'FzfLuaDirPart',        { fg = muted })
    vim.api.nvim_set_hl(0, 'FzfLuaLiveSym',        { fg = ok_fg })

    -- ─────────────────────────────────────────────────────────────
    -- lazy.nvim
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'LazyNormal',         { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'LazyBorder',         { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'LazyTitle',          { fg = bg, bg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'LazyH1',             { fg = bg, bg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'LazyH2',             { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'LazyComment',        { fg = muted, italic = true })
    vim.api.nvim_set_hl(0, 'LazyCommit',         { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'LazyCommitIssue',    { fg = info_fg })
    vim.api.nvim_set_hl(0, 'LazyCommitScope',    { fg = accent, italic = true })
    vim.api.nvim_set_hl(0, 'LazyCommitType',     { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'LazyDimmed',         { fg = muted })
    vim.api.nvim_set_hl(0, 'LazyDir',            { fg = info_fg })
    vim.api.nvim_set_hl(0, 'LazyLocal',          { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'LazyNoCond',         { fg = err_fg })
    vim.api.nvim_set_hl(0, 'LazyProgressDone',   { fg = ok_fg, bold = true })
    vim.api.nvim_set_hl(0, 'LazyProgressTodo',   { fg = muted })
    vim.api.nvim_set_hl(0, 'LazyProp',           { fg = muted })
    vim.api.nvim_set_hl(0, 'LazyReasonCmd',      { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'LazyReasonEvent',    { fg = info_fg })
    vim.api.nvim_set_hl(0, 'LazyReasonFt',       { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'LazyReasonImport',   { fg = accent })
    vim.api.nvim_set_hl(0, 'LazyReasonKeys',     { fg = accent })
    vim.api.nvim_set_hl(0, 'LazyReasonPlugin',   { fg = accent })
    vim.api.nvim_set_hl(0, 'LazyReasonSource',   { fg = info_fg })
    vim.api.nvim_set_hl(0, 'LazyReasonRuntime',  { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'LazyReasonStart',    { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'LazySpecial',        { fg = accent })
    vim.api.nvim_set_hl(0, 'LazyTaskDone',       { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'LazyTaskError',      { fg = err_fg })
    vim.api.nvim_set_hl(0, 'LazyUrl',            { fg = info_fg, underline = true })
    vim.api.nvim_set_hl(0, 'LazyButtonActive',   { fg = bg, bg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'LazyButton',         { fg = accent, bg = pmenu_bg, bold = true })


    -- ─────────────────────────────────────────────────────────────
    -- mini.notify
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'MiniNotifyBorder',    { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'MiniNotifyNormal',    { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'MiniNotifyTitle',     { fg = bg, bg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'MiniNotifyWindowTooTall', { fg = warn_fg })

    -- ─────────────────────────────────────────────────────────────
    -- oil.nvim
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'OilNormal',          { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'OilNormalNC',        { bg = bg, fg = muted })
    vim.api.nvim_set_hl(0, 'OilBorder',          { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'OilBorderNC',        { fg = muted, bg = bg })
    vim.api.nvim_set_hl(0, 'OilTitle',           { fg = bg, bg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'OilDir',             { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'OilDirIcon',         { fg = accent })
    vim.api.nvim_set_hl(0, 'OilLink',            { fg = info_fg, italic = true })
    vim.api.nvim_set_hl(0, 'OilLinkTarget',      { fg = info_fg })
    vim.api.nvim_set_hl(0, 'OilCopy',            { fg = ok_fg, bold = true })
    vim.api.nvim_set_hl(0, 'OilMove',            { fg = warn_fg, bold = true })
    vim.api.nvim_set_hl(0, 'OilChange',          { fg = chgd_fg, bold = true })
    vim.api.nvim_set_hl(0, 'OilCreate',          { fg = added_fg, bold = true })
    vim.api.nvim_set_hl(0, 'OilDelete',          { fg = deld_fg, bold = true })
    vim.api.nvim_set_hl(0, 'OilPermissionNone',  { fg = muted })
    vim.api.nvim_set_hl(0, 'OilPermissionRead',  { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'OilPermissionWrite', { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'OilPermissionExecute', { fg = err_fg })
    vim.api.nvim_set_hl(0, 'OilTypeFile',        { fg = muted })
    vim.api.nvim_set_hl(0, 'OilTypeDir',         { fg = accent })
    vim.api.nvim_set_hl(0, 'OilTypeLink',        { fg = info_fg })
    vim.api.nvim_set_hl(0, 'OilTypeSpecial',     { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'OilSize',            { fg = muted })
    vim.api.nvim_set_hl(0, 'OilMtime',           { fg = muted })
    vim.api.nvim_set_hl(0, 'OilMtimeHour',       { fg = info_fg })
    vim.api.nvim_set_hl(0, 'OilMtimeDay',        { fg = accent })
    vim.api.nvim_set_hl(0, 'OilMtimePast',       { fg = muted })
    vim.api.nvim_set_hl(0, 'OilMtimeNew',        { fg = ok_fg })

    -- ─────────────────────────────────────────────────────────────
    -- which-key.nvim
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'WhichKey',            { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'WhichKeyBorder',      { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'WhichKeyNormal',      { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'WhichKeyTitle',       { fg = bg, bg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'WhichKeyGroup',       { fg = info_fg, bold = true })
    vim.api.nvim_set_hl(0, 'WhichKeyDesc',        { fg = fg })
    vim.api.nvim_set_hl(0, 'WhichKeyValue',       { fg = muted })
    vim.api.nvim_set_hl(0, 'WhichKeySeparator',   { fg = border_fg })
    vim.api.nvim_set_hl(0, 'WhichKeyIcon',        { fg = accent })
    vim.api.nvim_set_hl(0, 'WhichKeyIconAzure',   { fg = info_fg })
    vim.api.nvim_set_hl(0, 'WhichKeyIconBlue',    { fg = info_fg })
    vim.api.nvim_set_hl(0, 'WhichKeyIconCyan',    { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'WhichKeyIconGreen',   { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'WhichKeyIconGrey',    { fg = muted })
    vim.api.nvim_set_hl(0, 'WhichKeyIconOrange',  { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'WhichKeyIconPurple',  { fg = accent })
    vim.api.nvim_set_hl(0, 'WhichKeyIconRed',     { fg = err_fg })
    vim.api.nvim_set_hl(0, 'WhichKeyIconYellow',  { fg = warn_fg })

    -- ─────────────────────────────────────────────────────────────
    -- crates.nvim
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'CratesNvimLoading',           { fg = muted, italic = true })
    vim.api.nvim_set_hl(0, 'CratesNvimVersion',           { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'CratesNvimPreRelease',        { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'CratesNvimYanked',            { fg = err_fg })
    vim.api.nvim_set_hl(0, 'CratesNvimNoMatch',           { fg = err_fg })
    vim.api.nvim_set_hl(0, 'CratesNvimUpgrade',           { fg = info_fg })
    vim.api.nvim_set_hl(0, 'CratesNvimError',             { fg = err_fg })
    vim.api.nvim_set_hl(0, 'CratesNvimPopupNormalBg',     { bg = pmenu_bg, fg = fg })
    vim.api.nvim_set_hl(0, 'CratesNvimPopupBorder',       { fg = border_fg, bg = pmenu_bg, bold = true })
    vim.api.nvim_set_hl(0, 'CratesNvimPopupTitle',        { fg = bg, bg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'CratesNvimPopupPillText',     { fg = bg, bg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'CratesNvimPopupPillBorder',   { fg = accent })
    vim.api.nvim_set_hl(0, 'CratesNvimPopupDescription',  { fg = muted, italic = true })
    vim.api.nvim_set_hl(0, 'CratesNvimPopupLabel',        { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'CratesNvimPopupUsed',         { fg = ok_fg, bold = true })
    vim.api.nvim_set_hl(0, 'CratesNvimPopupCompatible',   { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'CratesNvimPopupIncompatible', { fg = err_fg })

    -- ─────────────────────────────────────────────────────────────
    -- focus.nvim
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'FocusedWindow',   { bg = bg })
    vim.api.nvim_set_hl(0, 'UnfocusedWindow', { bg = hl_bg('NormalNC') or bg })

    -- ─────────────────────────────────────────────────────────────
    -- lazygit.nvim  (terminal float — uses FloatBorder/NormalFloat,
    --               but lazygit ships its own theme file;
    --               the groups below cover the nvim wrapper window)
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'LazyGitBorder',    { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'LazyGitFloat',     { bg = bg, fg = fg })

    -- ─────────────────────────────────────────────────────────────
    -- leap.nvim
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'LeapMatch',            { fg = accent, bold = true, underline = true })
    vim.api.nvim_set_hl(0, 'LeapLabelPrimary',     { fg = bg, bg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'LeapLabelSecondary',   { fg = bg, bg = info_fg, bold = true })
    vim.api.nvim_set_hl(0, 'LeapLabelSelected',    { fg = bg, bg = ok_fg, bold = true })
    vim.api.nvim_set_hl(0, 'LeapBackdrop',         { fg = muted })

    -- ─────────────────────────────────────────────────────────────
    -- lspkind-nvim  (kind icons shown inside completion menus)
    -- ─────────────────────────────────────────────────────────────
    -- lspkind reuses CmpItemKind* groups; set the ones blink.cmp
    -- doesn't cover when using lspkind as a formatter.
    vim.api.nvim_set_hl(0, 'CmpItemKindDefault',        { fg = accent })
    vim.api.nvim_set_hl(0, 'CmpItemMenu',               { fg = muted, italic = true })
    vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch',          { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy',     { fg = accent })
    vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated',     { fg = muted, strikethrough = true })

    -- ─────────────────────────────────────────────────────────────
    -- nui.nvim  (popup / layout / input / menu / tree / split)
    -- (dressing.nvim uses nui internally; groups below are for
    --  anything that exposes nui highlights directly)
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'NuiComponentBorder', { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'NuiNormal',          { bg = bg, fg = fg })

    -- ─────────────────────────────────────────────────────────────
    -- overseer.nvim  (task runner)
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'OverseerPENDING',   { fg = muted })
    vim.api.nvim_set_hl(0, 'OverseerWAITING',   { fg = info_fg })
    vim.api.nvim_set_hl(0, 'OverseerRUNNING',   { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'OverseerSUCCESS',   { fg = ok_fg, bold = true })
    vim.api.nvim_set_hl(0, 'OverseerCANCELED',  { fg = muted })
    vim.api.nvim_set_hl(0, 'OverseerFAILURE',   { fg = err_fg, bold = true })
    vim.api.nvim_set_hl(0, 'OverseerTask',      { fg = fg })
    vim.api.nvim_set_hl(0, 'OverseerTaskBorder',{ fg = border_fg, bold = true })
    vim.api.nvim_set_hl(0, 'OverseerOutput',    { fg = fg })
    vim.api.nvim_set_hl(0, 'OverseerComponent', { fg = info_fg })
    vim.api.nvim_set_hl(0, 'OverseerField',     { fg = accent })

    -- ─────────────────────────────────────────────────────────────
    -- toggleterm.nvim
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'ToggleTerm',            { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'ToggleTermBorder',      { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'ToggleTermFloat',       { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'ToggleTermFloatBorder', { fg = border_fg, bg = bg, bold = true })

    -- ─────────────────────────────────────────────────────────────
    -- trouble.nvim  (diagnostics, references, quickfix list)
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'TroubleNormal',         { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'TroubleNormalNC',       { bg = bg, fg = muted })
    vim.api.nvim_set_hl(0, 'TroubleCount',          { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'TroubleText',           { fg = fg })
    vim.api.nvim_set_hl(0, 'TroubleTextError',      { fg = err_fg })
    vim.api.nvim_set_hl(0, 'TroubleTextWarning',    { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'TroubleTextInformation',{ fg = info_fg })
    vim.api.nvim_set_hl(0, 'TroubleTextHint',       { fg = hint_fg })
    vim.api.nvim_set_hl(0, 'TroubleError',          { fg = err_fg })
    vim.api.nvim_set_hl(0, 'TroubleWarning',        { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'TroubleInformation',    { fg = info_fg })
    vim.api.nvim_set_hl(0, 'TroubleHint',           { fg = hint_fg })
    vim.api.nvim_set_hl(0, 'TroubleLocation',       { fg = muted })
    vim.api.nvim_set_hl(0, 'TroubleFile',           { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'TroubleIndent',         { fg = border_fg })
    vim.api.nvim_set_hl(0, 'TroubleSource',         { fg = muted, italic = true })
    vim.api.nvim_set_hl(0, 'TroubleCode',           { fg = muted })
    vim.api.nvim_set_hl(0, 'TroubleSignText',       { fg = err_fg })
    vim.api.nvim_set_hl(0, 'TroubleIconError',      { fg = err_fg })
    vim.api.nvim_set_hl(0, 'TroubleIconWarning',    { fg = warn_fg })
    vim.api.nvim_set_hl(0, 'TroubleIconInformation',{ fg = info_fg })
    vim.api.nvim_set_hl(0, 'TroubleIconHint',       { fg = hint_fg })
    vim.api.nvim_set_hl(0, 'TroubleIconOther',      { fg = accent })
    vim.api.nvim_set_hl(0, 'TroubleIconDirectory',  { fg = accent })
    vim.api.nvim_set_hl(0, 'TroubleIconFile',       { fg = fg })
    vim.api.nvim_set_hl(0, 'TroublePreview',        { bg = sel_bg })
    vim.api.nvim_set_hl(0, 'TroubleFocusedItem',    { bg = sel_bg, bold = true })
    vim.api.nvim_set_hl(0, 'TroublePos',            { fg = muted })
    vim.api.nvim_set_hl(0, 'TroubleBasename',       { fg = fg, bold = true })

    -- ─────────────────────────────────────────────────────────────
    -- undotree
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'UndotreeNode',          { fg = accent, bold = true })
    vim.api.nvim_set_hl(0, 'UndotreeNodeCurrent',   { fg = ok_fg, bold = true })
    vim.api.nvim_set_hl(0, 'UndotreeSeq',           { fg = muted })
    vim.api.nvim_set_hl(0, 'UndotreeCurrent',       { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'UndotreeNext',          { fg = accent })
    vim.api.nvim_set_hl(0, 'UndotreeTimeStamp',     { fg = muted, italic = true })
    vim.api.nvim_set_hl(0, 'UndotreeFirstNode',     { fg = warn_fg, bold = true })
    vim.api.nvim_set_hl(0, 'UndotreeBranch',        { fg = info_fg })
    vim.api.nvim_set_hl(0, 'UndotreeHead',          { fg = ok_fg, bold = true })
    vim.api.nvim_set_hl(0, 'UndotreeSavedBig',      { fg = ok_fg, bold = true })
    vim.api.nvim_set_hl(0, 'UndotreeSavedSmall',    { fg = ok_fg })
    vim.api.nvim_set_hl(0, 'UndotreeHelp',          { fg = muted, italic = true })

    -- ─────────────────────────────────────────────────────────────
    -- vim-visual-multi
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'VM_Extend',          { bg = sel_bg, fg = sel_fg })
    vim.api.nvim_set_hl(0, 'VM_Cursor',          { bg = accent, fg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'VM_Insert',          { bg = ok_fg, fg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'VM_Mono',            { bg = warn_fg, fg = bg, bold = true })
    -- vim-visual-multi also reads these legacy names
    vim.api.nvim_set_hl(0, 'MultiCursor',        { bg = accent, fg = bg })
    vim.api.nvim_set_hl(0, 'MultiCursorVisual',  { bg = sel_bg })

    -- ─────────────────────────────────────────────────────────────
    -- yazi.nvim  (floating yazi terminal)
    -- ─────────────────────────────────────────────────────────────
    vim.api.nvim_set_hl(0, 'YaziFloat',          { bg = bg, fg = fg })
    vim.api.nvim_set_hl(0, 'YaziFloatBorder',    { fg = border_fg, bg = bg, bold = true })
    vim.api.nvim_set_hl(0, 'YaziFloatTitle',     { fg = bg, bg = border_fg, bold = true })

    -- ─────────────────────────────────────────────────────────────
    -- resession.nvim  (no public hl groups; uses normal float/input)
    -- nvim-osc52      (no UI highlights — clipboard provider)
    -- nvim-treesitter (uses standard @* capture groups)
    -- friendly-snippets (no UI highlights — snippet source)
    -- mini.icons      (delegates to DevIcon* / MiniIcons* groups below)
    -- mini.move       (no dedicated highlights)
    -- nvim-surround   (no dedicated highlights — uses Normal)
    -- nvim-ts-autotag (no dedicated highlights)
    -- ultimate-autopair (no dedicated highlights)
    -- plenary.nvim    (test runner uses DiagnosticOk/Error)
    -- nvim-nio        (internal async lib; no UI highlights)
    -- ─────────────────────────────────────────────────────────────
end

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = M.setup,
})

M.setup()
return M
