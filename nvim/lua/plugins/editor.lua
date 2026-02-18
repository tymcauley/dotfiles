return {
    -- Fuzzy finder
    {
        "ibhagwan/fzf-lua",
        priority = 1000,
        lazy = false,
        opts = {
            lsp = {
                async_or_timeout = true,
                code_actions = {
                    previewer = "codeaction_native",
                },
            },
        },
        config = function(_, opts)
            require("fzf-lua").setup(opts)
            require("fzf-lua").register_ui_select()
        end,
        keys = {
            -- stylua: ignore start
            { "<leader>ff", function() require("fzf-lua").files() end, desc = "Find files" },
            { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
            { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "Grep" },
            { "<leader>fr", function() require("fzf-lua").resume() end, desc = "Resume last picker" },
            -- LSP
            { "gd", function() require("fzf-lua").lsp_definitions() end, desc = "Goto Definition" },
            { "gr", function() require("fzf-lua").lsp_references() end, nowait = true, desc = "References" },
            { "gI", function() require("fzf-lua").lsp_implementations() end, desc = "Goto Implementation" },
            { "gy", function() require("fzf-lua").lsp_typedefs() end, desc = "Goto T[y]pe Definition" },
            { "<leader>ss", function() require("fzf-lua").lsp_document_symbols() end, desc = "LSP Symbols" },
            -- stylua: ignore end
        },
    },

    -- Collection of quality-of-life plugins
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            notifier = { enabled = true },
            input = { enabled = true },
            styles = {
                notification = {
                    wo = { wrap = true }, -- Wrap notifications
                },
                notification_history = {
                    wo = { wrap = true }, -- Wrap notifications
                },
            },
        },
        keys = {
            -- stylua: ignore start
            { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
            { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
            { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
            { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
            { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
            { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
            { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
            -- stylua: ignore end
        },
    },

    -- Performant indent guides
    {
        "saghen/blink.indent",
    },

    -- Add nice integration with git
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            signs_staged = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            -- Set up buffer mappings
            on_attach = function(bufnr)
                local gs = require("gitsigns")

                -- Define buffer-local mapping
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, "Next hunk")

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, "Prev hunk")

                -- Actions
                map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
                map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
                map("v", "<leader>ghs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage hunk")
                map("v", "<leader>ghr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
                map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>ghb", function()
                    gs.blame_line({ full = true })
                end, "Blame line")
                map("n", "<leader>ghd", gs.diffthis, "Diff this")
                map("n", "<leader>ghD", function()
                    gs.diffthis("~")
                end, "Diff this ~")
                map("n", "<leader>ghtb", gs.toggle_current_line_blame, "Toggle blame annotation")

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns select hunk")
            end,
        },
    },

    -- Git diff viewer
    {
        "esmuellert/codediff.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        cmd = "CodeDiff",
    },

    -- Generate permalinks for git host websites
    {
        "linrongbin16/gitlinker.nvim",
        lazy = true,
        keys = {
            {
                "<leader>gll",
                "<Cmd>GitLink<CR>",
                mode = { "n", "v" },
                silent = true,
                noremap = true,
                desc = "Copy git permlink to clipboard",
            },
            {
                "<leader>glL",
                "<Cmd>GitLink!<CR>",
                mode = { "n", "v" },
                silent = true,
                noremap = true,
                desc = "Open git permlink in browser",
            },
            {
                "<leader>glb",
                "<Cmd>GitLink blame<CR>",
                mode = { "n", "v" },
                silent = true,
                noremap = true,
                desc = "Copy git blame link to clipboard",
            },
            {
                "<leader>glB",
                "<Cmd>GitLink! blame<CR>",
                mode = { "n", "v" },
                silent = true,
                noremap = true,
                desc = "Open git blame link in browser",
            },
        },
        opts = function()
            -- Check if custom routers are defined in the private file.
            local ok, private = pcall(require, "private")
            if ok and private.gitlinker_routers then
                return { router = private.gitlinker_routers }
            end
            return {}
        end,
    },

    -- Better quickfix window
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
    },

    -- Window for diagnostics
    {
        "folke/trouble.nvim",
        opts = {},
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
}
