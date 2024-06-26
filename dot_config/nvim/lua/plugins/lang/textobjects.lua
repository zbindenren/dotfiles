local textobjects = {
    select = {
        enable = true,
        lookahead = true,

        keymaps = {
            ['af'] = {
                query = '@function.outer',
                desc = 'Select outer part of a method/function definition',
            },
            ['if'] = {
                query = '@function.inner',
                desc = 'Select inner part of a method/function definition',
            },
        },
    },
}

local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')

-- vim way: ; goes to the direction you were moving.
vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f)
vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F)
vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t)
vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T)

return textobjects
