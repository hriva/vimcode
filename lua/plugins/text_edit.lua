local my_augroup = require('conf.builtin_extend').my_augroup
local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.api.nvim_set_keymap

local M = {
    {
        'echasnovski/mini.ai',
        enabled = false,
        event = 'LazyFile',
        config = function()
            require('mini.ai').setup {
                custom_textobjects = {
                    -- See `echasnovski/mini.nvim #366`. Mini.ai handle quotes
                    -- worse than vim's default.
                    ['"'] = false,
                    ["'"] = false,
                },
                mappings = {
                    -- Next/last variants
                    around_next = 'an',
                    inside_next = 'in',
                    around_last = 'aN',
                    inside_last = 'iN',
                    -- Move cursor to corresponding edge of `a` textobject
                    goto_left = 'g(',
                    goto_right = 'g)',
                },
                n_lines = 200,
            }
        end
        },
        {'echasnovski/mini.surround',
        enabled = false,
        event = 'LazyFile',
        config = function()
            require('mini.surround').setup {
                mappings = {
                    add = '<Plug>(mini-surround-add)',
                    delete = '<Plug>(mini-surround-delete)',
                    find = '<Plug>(mini-surround-find)',
                    find_left = '<Plug>(mini-surround-find_left)',
                    highlight = '<Plug>(mini-surround-highlight)',
                    replace = '<Plug>(mini-surround-replace)',
                    update_n_lines = '<Plug>(mini-surround-update_n_lines)',
                },
            }
        end
        }
}

return M
