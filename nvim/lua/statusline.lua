local M = {}
local ll = require('lualine')

-- Returns a single character representing the current Vim mode.
--
-- See ':help mode()' for context.
local function mode_single_character()
    local mode_strings = {
        n = 'N',
        i = 'I',
        v = 'V',
        V = 'V',
        [''] = 'V', -- visual block
        c = 'C',
        s = 'S',
        S = 'S',
        [''] = 'S', -- select block
        R = 'R',
        r = 'P',
        ['!'] = '!',
        t = 'T',
    }
    local default_string = '?'
    return mode_strings[vim.fn.mode()] or default_string
end

M.setup = function()
    local ll_options = {
        section_separators = {'', ''},
        component_separators = {'', ''},
        theme = 'auto',
        disabled_filetypes = {'packer'},
    }

    local ll_sections = {
        lualine_a = {mode_single_character},
        -- TODO: It would be nice to prefix the file name with the file icon
        lualine_b = {'filename'},
        lualine_c = {
            {'branch', icon = ''},
            'diff',
        },
        lualine_x = {
            {'diagnostics', sources = {'nvim_lsp'}},
            -- Display nvim-metals status for Scala files
            {
                function()
                    return vim.g['metals_status'] or ''
                end,
                condition = function()
                    local filetype = vim.bo.filetype
                    return filetype == 'scala' or filetype == 'sbt'
                end,
            }
        },
        lualine_y = {'filetype'},
        lualine_z = {'progress', 'location'},
    }

    local ll_inactive_sections = {
        lualine_c = {'filename'},
        lualine_x = {'location'},
    }

    ll.setup {
        options = ll_options,
        sections = ll_sections,
        inactive_sections = ll_inactive_sections,
    }
end

return M
