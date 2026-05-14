local M = {}

function M.setup(npairs)
    local Rule = require('nvim-autopairs.rule')
    local cond = require('nvim-autopairs.conds')

    -- ==========================================
    -- RUST
    -- ==========================================
    npairs.add_rules({
        -- Generics: Vec<T>, HashMap<K, V>
        Rule('<', '>', 'rust')
            :with_pair(cond.before_regex('[%w%:]'))
            :with_move(function(opts) return opts.char == '>' end),

        -- Macros: println!() — trigger on ( after !
        Rule('!%(', ')', 'rust')
            :use_key('(')
            :replace_endpair(function(opts)
                return opts.prev_char == '!' and ')' or ''
            end),
    })
end

return M
