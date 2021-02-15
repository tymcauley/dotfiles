local M = {}
local gl = require('galaxyline')
local gls = gl.section
local condition = require('galaxyline.condition')
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
            condition = condition.buffer_not_empty,
            highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.line_bg},
        }
    }
    gls.left[5] = {
        FileName = {
            provider = 'FileName',
            condition = condition.buffer_not_empty,
            highlight = {colors.fg, colors.line_bg, 'bold'},
        }
    }
    gls.left[6] = {
        SeparatorLeft2 = {
            provider = empty_section,
            condition = condition.buffer_not_empty,
            separator = ' ',
            separator_highlight = {colors.line_bg, colors.bg},
        }
    }
    gls.left[7] = {
        GitIcon = {
            provider = function() return ' ' end,
            condition = condition.check_git_workspace,
            highlight = {colors.orange, colors.bg},
        }
    }
    gls.left[8] = {
        GitBranch = {
            provider = 'GitBranch',
            condition = condition.check_git_workspace,
            highlight = {colors.fg, colors.bg, 'bold'},
        }
    }
    gls.left[9] = {
        DiffAdd = {
            provider = 'DiffAdd',
            condition = condition.hide_in_width,
            icon = ' ',
            highlight = {colors.green, colors.bg},
        }
    }
    gls.left[10] = {
        DiffModified = {
            provider = 'DiffModified',
            condition = condition.hide_in_width,
            icon = ' ',
            highlight = {colors.orange, colors.bg},
        }
    }
    gls.left[11] = {
        DiffRemove = {
            provider = 'DiffRemove',
            condition = condition.hide_in_width,
            icon = ' ',
            highlight = {colors.red, colors.bg},
        }
    }
    gls.left[12] = {
        SeparatorLeft3 = {
            provider = empty_section,
            condition = condition.buffer_not_empty,
            separator = ' ',
            separator_highlight = {colors.bg, colors.line_bg},
        }
    }
    gls.left[13] = {
        DiagnosticError = {
            provider = 'DiagnosticError',
            condition = condition.buffer_not_empty,
            icon = ' ',
            highlight = {colors.red, colors.line_bg},
            separator = '',
            separator_highlight = {colors.line_bg, colors.line_bg},
        }
    }
    gls.left[14] = {
        DiagnosticWarn = {
            provider = 'DiagnosticWarn',
            condition = condition.buffer_not_empty,
            icon = ' ',
            highlight = {colors.orange, colors.line_bg},
            separator = '',
            separator_highlight = {colors.line_bg, colors.line_bg},
        }
    }
    gls.left[15] = {
        DiagnosticInfo = {
            provider = 'DiagnosticInfo',
            condition = condition.buffer_not_empty,
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
            condition = condition.hide_in_width,
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
            condition = condition.buffer_not_empty,
            highlight = {colors.fg, colors.line_bg, 'bold'},
            separator = ' ▋ ',
            separator_highlight = {colors.blue, colors.line_bg},
        }
    }

    -- Short status line

    gls.short_line_left[1] = {
        ShortFileIcon = {
            provider = 'FileIcon',
            condition = condition.buffer_not_empty,
            highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.bg},
        }
    }
    gls.short_line_left[2] = {
        ShortFileName = {
            provider = 'FileName',
            condition = condition.buffer_not_empty,
            highlight = {colors.fg, colors.bg, 'bold'},
        }
    }

    gls.short_line_right[1]= {
        ShortFileType = {
            provider = function() return vim.bo.filetype end,
            condition = condition.hide_in_width,
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
