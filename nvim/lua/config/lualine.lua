local M = {}
local ll = require("lualine")
local navic = require("nvim-navic")

M.setup = function()
    ll.setup({
        options = {
            section_separators = { left = "", right = "" },
            component_separators = { left = "", right = "" },
            theme = "tokyonight",
            globalstatus = true,
        },

        sections = {
            lualine_a = {
                -- Return a single character representing the current Vim mode.
                {
                    "mode",
                    fmt = function(str)
                        return str:sub(1, 1)
                    end,
                },
            },
            lualine_b = {
                -- Prefix file name with file icon
                {
                    "filetype",
                    icon_only = true,
                    separator = "",
                    padding = { left = 1, right = 0 },
                },
                {
                    "filename",
                    path = 0,
                },
            },
            lualine_c = {
                {
                    "b:gitsigns_head",
                    icon = "",
                },
                {
                    "b:gitsigns_status",
                },
                -- Display code context
                {
                    navic.get_location,
                    cond = navic.is_available,
                },
            },
            lualine_x = {
                -- LSP diagnostics
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                },
            },
            lualine_y = {
                {
                    "filetype",
                    icons_enabled = false,
                },
            },
            lualine_z = {
                -- Display file format for non-unix files
                {
                    "fileformat",
                    cond = function()
                        return vim.bo.fileformat ~= "unix"
                    end,
                },
                "progress",
                "location",
            },
        },

        inactive_sections = {
            lualine_c = { "filename" },
            lualine_x = { "location" },
        },
    })
end

return M
