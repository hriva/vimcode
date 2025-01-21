local autocmd = vim.api.nvim_create_autocmd
local my_augroup = require('conf.builtin_extend').my_augroup
local keymap = vim.api.nvim_set_keymap

local function list_filter(parent_list, excluded_list)
    return vim.tbl_filter(function(item)
        return not vim.tbl_contains(excluded_list, item)
    end, parent_list)
end

TS_Parsers = {
    'r',
    'python',
    'cpp',
    'lua',
    'vim',
    'vimdoc',
    'yaml',
    'toml',
    'json',
    'html',
    'css',
    'javascript',
    'regex',
    'markdown',
    'markdown_inline',
    'go',
    'sql',
    'bash',
}

-- highlight
local disable_highlight = { 'sql', 'tex', 'latex', 'markdown_inline', 'regex', 'bash' }
TS_Parsers_Enabled_for_Highlight = list_filter(TS_Parsers, disable_highlight)
table.insert(TS_Parsers_Enabled_for_Highlight, 'quarto')
table.insert(TS_Parsers_Enabled_for_Highlight, 'rmd')

-- indent
local disable_indent = { 'python', 'sql', 'tex', 'latex', 'markdown_inline', 'regex', 'bash' }
TS_Parsers_Enabled_for_Indent = list_filter(TS_Parsers, disable_indent)

-- fold
TS_Parsers_Enabled_for_Fold = {
    'python',
    'c',
    'cpp',
    'go',
    'html',
    'javascript',
    'json',
    'tex',
    'markdown',
    'lua',
    'query',
    'vim',
    'toml',
    'yaml',
}

local disable_textobj = { 'sql', 'tex', 'latex', 'markdown_inline', 'regex', 'bash', 'vimdoc' }
TS_Parsers_Enabled_for_Text_Objs = list_filter(TS_Parsers, disable_textobj)

return {
    {
        'nvim-treesitter/nvim-treesitter',
        -- lazy load configs are copied from lazyvim/plugins/treesitter.lua
        -- NOTE: This is a simplifed version. If in future there are bugs happened,
        -- will consult to lazyvim.
        event = { 'LazyFile' },
        cmd = { 'TSUpdate', 'TSInstall' },
        build = ':TSUpdate',
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        branch = 'master',
        config = function()
            if vim.fn.executable 'tree-sitter' == 0 then
                if not require('mason-registry').is_installed 'tree-sitter-cli' then
                    vim.cmd [[MasonInstall tree-sitter-cli]]
                end
            end

            require('nvim-treesitter.configs').setup {
                ensure_installed = TS_Parsers,
                auto_install = false,
                highlight = {
                    -- we manage highlight by ourself
                    enable = false,
                },
                indent = {
                    enable = TS_Parsers_Enabled_for_Indent,
                },
            }

            vim.treesitter.language.register('markdown', { 'quarto', 'rmd' })

            autocmd('FileType', {
                pattern = { 'quarto', 'rmd' },
                group = my_augroup,
                desc = 'Enable regex highlight with treesitter',
                callback = function()
                    vim.cmd [[setlocal syntax=on]]
                end,
            })
        end,
    }

}
