return {
    -- Languages
    { "azidar/firrtl-syntax", event = "VeryLazy" },
    { "rust-lang/rust.vim", event = "VeryLazy" },
    { "tymcauley/llvm-vim-syntax", event = "VeryLazy" },

    -- Column-align multiple lines
    {
        "echasnovski/mini.align",
        event = "VeryLazy",
        opts = {
            mappings = {
                start = "ga",
                start_with_preview = "gA",
            },
        },
    },

    -- Automatic closing of quotes, parens, brackets, etc
    {
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup({})

            -- In Verilog/SystemVerilog, backtick is used for text macros, so disable autopairs for those files
            npairs.get_rule("`").not_filetypes = { "verilog", "systemverilog" }

            -- TODO this isn't working right, it's inserting an extra backtick at the end
            -- -- In rST, match double backticks
            -- npairs.add_rule(Rule("``", "``", "rst"))
        end,
    },

    -- Easy comment insertion
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        opts = {}, -- `opts = {}` is the same as calling `require("Comment").setup({})`
    },

    -- Make a new text object for lines at the same indent level
    { "michaeljsmith/vim-indent-object", event = "VeryLazy" },

    -- Surround actions
    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        opts = {
            mappings = {
                add = "gsa", -- Add surrounding in Normal and Visual modes
                delete = "gsd", -- Delete surrounding
                find = "gsf", -- Find surrounding (to the right)
                find_left = "gsF", -- Find surrounding (to the left)
                highlight = "gsh", -- Highlight surrounding
                replace = "gsr", -- Replace surrounding
                update_n_lines = "gsn", -- Update `n_lines`
            },
        },
    },

    -- Commands for smart text substitution
    { "tpope/vim-abolish", event = "VeryLazy" },

    -- Improved match motions
    {
        "haya14busa/vim-asterisk",
        event = "VeryLazy",
        config = function()
            -- Don't move to the next match immediately
            vim.keymap.set("", "*", "<Plug>(asterisk-z*)")
            vim.keymap.set("", "#", "<Plug>(asterisk-z#)")
            vim.keymap.set("", "g*", "<Plug>(asterisk-gz*)")
            vim.keymap.set("", "g#", "<Plug>(asterisk-gz#)")

            -- Keep cursor position across matches
            vim.g["asterisk#keeppos"] = 1
        end,
    },

    -- Automatic table creator
    {
        "dhruvasagar/vim-table-mode",
        event = "VeryLazy",
        config = function()
            -- Fix table formatting for ReST and Markdown files
            local ft = vim.bo.filetype
            if ft == "rst" then
                vim.cmd("let b:table_mode_corner_corner = '+'")
                vim.cmd("let b:table_mode_header_fillchar = '='")
            elseif ft == "markdown" then
                vim.cmd("let b:table_mode_corner = '|'")
            end
        end,
    },

    -- Autocompletion plugin
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-calc",
        },
        opts = function()
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local feedkey = function(key, mode)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
            end

            local cmp = require("cmp")
            return {
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = {
                    ["<C-n>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif vim.fn["vsnip#available"](1) == 1 then
                            feedkey("<Plug>(vsnip-expand-or-jump)", "")
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i" }),
                    ["<C-p>"] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                            feedkey("<Plug>(vsnip-jump-prev)", "")
                        end
                    end, { "i" }),
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
                    ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i" }),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                    { name = "nvim_lsp_signature_help" },
                }, {
                    { name = "nvim_lua" },
                    { name = "buffer" },
                    { name = "path" },
                    { name = "calc" },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.menu = ({
                            nvim_lsp = "",
                            buffer = "",
                        })[entry.source.name]
                        vim_item.kind = ({
                            Text = "󰀬",
                            Method = "󰊕",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "",
                            Variable = "",
                            Class = "",
                            Interface = "󰜰",
                            Module = "󰏗",
                            Property = "",
                            Unit = "",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "󰘍",
                            Color = "",
                            File = "",
                            Reference = "󰆑",
                            Folder = "",
                            EnumMember = "",
                            Constant = "",
                            Struct = "",
                            Event = "",
                            Operator = "󰘧",
                            TypeParameter = "",
                        })[vim_item.kind] .. " " .. vim_item.kind
                        return vim_item
                    end,
                },
            }
        end,
        config = function(_, opts)
            require("cmp").setup(opts)

            -- Insert '(' after select function or method item
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- Smart selection of closest text object
    {
        "sustech-data/wildfire.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {},
    },
}
