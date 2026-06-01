-- require("user.sys.profiler") -- Precedence = #1 (for profiling)
require('user.sys.options') -- Precedence = #2
require('user.sys')
require('user.mini')
require('user.ui.core')
require('user.config.ide')
require('user.config.tools')
require('user.config.server')
vim.cmd.colorscheme("tokyonight-moon")
require("user.ui.core.eqalizer")
-- =========================================================
-- 3. Post-init
-- =========================================================
