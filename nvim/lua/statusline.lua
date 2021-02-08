local M = {}
local gl = require('galaxyline')
local gls = gl.section
gl.short_line_list = {'packer'}

local colors = {
    bg = '#282c34', -- black
    line_bg = '#353644',
    fg = '#abb2bf', -- white

    dark_red = '#be5046',
    dark_yellow = '#d19a66',
    gutter_grey = '#4b5263',
    comment_grey = '#5c6370',

    yellow = '#e5c07b', -- light yellow
    cyan = '#56b6c2', -- cyan
    green = '#98c379', -- green
    orange = '#be5046',
    purple = '#5d4d7a',
    magenta = '#c678dd', -- magenta
    blue = '#61afef', -- blue
    red = '#e06c75' -- light red
}

-- Helper functions

local empty_section = function() return '' end

-- Returns 'true' if current buffer is not empty
local is_buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
end

-- Returns 'true' if the current buffer is not empty and is in a git workspace
local is_nonempty_git_buffer = function()
    return is_buffer_not_empty() and require('galaxyline.provider_vcs').check_git_workspace()
end

-- Returns 'true' if the window width is greater than the given number of columns
local is_win_width_gt = function(cols)
    return vim.fn.winwidth(0) > cols
end

local checkwidth = function(cols)
    return is_win_width_gt(cols) and is_buffer_not_empty()
end

local mode_color = function()
    local mode_colors = {
        n = colors.blue,
        i = colors.green,
        v = colors.magenta,
        V = colors.magenta,
        [''] = colors.magenta, -- visual block
        c = colors.red,
        s = colors.orange,
        S = colors.orange,
        [''] = colors.orange, -- select block
        R = colors.purple,
        r = colors.cyan,
        ['!'] = colors.red,
        t = colors.red
    }
    local default_color = colors.magenta
    return mode_colors[vim.fn.mode()] or default_color
end

local mode_string = function()
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
    local default_string = '-'
    return mode_strings[vim.fn.mode()] or default_string
end

-- Width definitions
-- TODO: These should also be a function of available width, not just window
-- width. Any easy way to get that?
local min_width_1 = 60
local min_width_2 = 50
local checkwidth_1 = function() return checkwidth(min_width_1) end
local checkwidth_2 = function() return checkwidth(min_width_2) end

-- Statusline definition

M.setup = function()
    -- Left side

    gls.left[1] = {
        FirstElement = {
            provider = function()
                vim.api.nvim_command('hi GalaxyFirstElement guifg=' .. mode_color())
                return '▋'
            end,
            highlight = {colors.cyan, colors.bg},
        },
    }
    gls.left[2] = {
        ViMode = {
            provider = function()
                vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color())
                return mode_string() .. ' '
            end,
            highlight = {colors.bg, colors.bg, 'bold'},
        }
    }
    gls.left[3] = {
        SeparatorLeft1 = {
            provider = empty_section,
            separator = ' ',
            separator_highlight = {colors.bg, colors.line_bg},
        }
    }
    gls.left[4] = {
        FileIcon = {
            provider = 'FileIcon',
            condition = is_buffer_not_empty,
            highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.line_bg},
        }
    }
    gls.left[5] = {
        FileName = {
            provider = 'FileName',
            condition = is_buffer_not_empty,
            highlight = {colors.fg, colors.line_bg, 'bold'},
        }
    }
    gls.left[6] = {
        SeparatorLeft2 = {
            provider = empty_section,
            condition = is_buffer_not_empty,
            separator = ' ',
            separator_highlight = {colors.line_bg, colors.bg},
        }
    }
    gls.left[7] = {
        GitIcon = {
            provider = function() return ' ' end,
            condition = is_nonempty_git_buffer,
            highlight = {colors.orange, colors.bg},
        }
    }
    gls.left[8] = {
        GitBranch = {
            provider = 'GitBranch',
            condition = is_nonempty_git_buffer,
            highlight = {colors.fg, colors.bg, 'bold'},
        }
    }
    gls.left[9] = {
        DiffAdd = {
            provider = 'DiffAdd',
            condition = checkwidth_1,
            icon = ' ',
            highlight = {colors.green, colors.bg},
        }
    }
    gls.left[10] = {
        DiffModified = {
            provider = 'DiffModified',
            condition = checkwidth_1,
            icon = ' ',
            highlight = {colors.orange, colors.bg},
        }
    }
    gls.left[11] = {
        DiffRemove = {
            provider = 'DiffRemove',
            condition = checkwidth_1,
            icon = ' ',
            highlight = {colors.red, colors.bg},
        }
    }
    gls.left[12] = {
        SeparatorLeft3 = {
            provider = empty_section,
            condition = is_buffer_not_empty,
            separator = ' ',
            separator_highlight = {colors.bg, colors.line_bg},
        }
    }
    gls.left[13] = {
        DiagnosticError = {
            provider = 'DiagnosticError',
            condition = is_buffer_not_empty,
            icon = ' ',
            highlight = {colors.red, colors.line_bg},
            separator = '',
            separator_highlight = {colors.line_bg, colors.line_bg},
        }
    }
    gls.left[14] = {
        DiagnosticWarn = {
            provider = 'DiagnosticWarn',
            condition = is_buffer_not_empty,
            icon = ' ',
            highlight = {colors.orange, colors.line_bg},
            separator = '',
            separator_highlight = {colors.line_bg, colors.line_bg},
        }
    }
    gls.left[15] = {
        DiagnosticInfo = {
            provider = 'DiagnosticInfo',
            condition = is_buffer_not_empty,
            icon = ' ',
            highlight = {colors.blue, colors.line_bg},
            separator = '',
            separator_highlight = {colors.line_bg, colors.line_bg},
        }
    }
    gls.left[16] = {
        MetalsStatus = {
            provider = function()
                return vim.g['metals_status'] or ''
            end,
            condition = function()
                local filetype = vim.bo.filetype
                return filetype == 'scala' or filetype == 'sbt'
            end,
            highlight = {colors.fg, colors.line_bg},
        }
    }

    -- Right side

    gls.right[1]= {
        FileType = {
            provider = function() return vim.bo.filetype end,
            condition = checkwidth_2,
            highlight = {colors.fg, colors.line_bg},
        }
    }
    gls.right[2] = {
        LineInfo = {
            provider = {'LinePercent', 'LineColumn'},
            highlight = {colors.fg, colors.line_bg, 'bold'},
            separator = ' ▋',
            separator_highlight = {colors.blue, colors.line_bg},
        }
    }
    gls.right[3] = {
        FileSize = {
            provider = 'FileSize',
            condition = is_buffer_not_empty,
            highlight = {colors.fg, colors.line_bg, 'bold'},
            separator = ' ▋ ',
            separator_highlight = {colors.blue, colors.line_bg},
        }
    }

    -- Short status line

    gls.short_line_left[1] = {
        ShortFileIcon = {
            provider = 'FileIcon',
            condition = is_buffer_not_empty,
            highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.bg},
        }
    }
    gls.short_line_left[2] = {
        ShortFileName = {
            provider = 'FileName',
            condition = is_buffer_not_empty,
            highlight = {colors.fg, colors.bg, 'bold'},
        }
    }

    gls.short_line_right[1]= {
        ShortFileType = {
            provider = function() return vim.bo.filetype end,
            condition = checkwidth_2,
            highlight = {colors.fg, colors.bg},
        }
    }
    gls.short_line_right[2] = {
        ShortLineInfo = {
            provider = {'LinePercent', 'LineColumn'},
            highlight = {colors.fg, colors.bg, 'bold'},
            separator = ' |',
            separator_highlight = {colors.blue, colors.bg},
        }
    }
    gls.short_line_right[3] = {
        ShortFileSize = {
            provider = 'FileSize',
            highlight = {colors.fg, colors.bg, 'bold'},
            separator = ' | ',
            separator_highlight = {colors.blue, colors.bg},
        }
    }
end

return M
