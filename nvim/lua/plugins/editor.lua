return {
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
            -- Set up buffer mappings
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                -- Define buffer-local mapping
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                end

                -- Actions
                map("n", "]c", gs.next_hunk, "Next hunk")
                map("n", "[c", gs.prev_hunk, "Prev hunk")
                map("n", "<leader>ghs", gs.stage_hunk, "Stage hunk")
                map("n", "<leader>ghr", gs.reset_hunk, "Reset hunk")
                map("v", "<leader>ghs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage hunk")
                map("v", "<leader>ghr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset hunk")
                map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
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
                map("n", "<leader>ghtd", gs.toggle_deleted, "Toggle deleted hunks")

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns select hunk")
            end,
        },
    },

    -- Git diff viewer
    {
        "sindrets/diffview.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Improve fuzzy finding performance for `telescope.nvim`
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            },
            -- Picker for live-grep args
            { "nvim-telescope/telescope-live-grep-args.nvim" },
        },
        cmd = "Telescope",
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "Find files",
            },
            {
                "<leader>fg",
                function()
                    require("telescope").extensions.live_grep_args.live_grep_args()
                end,
                desc = "Grep",
            },
            {
                "<leader>fb",
                function()
                    require("telescope.builtin").buffers()
                end,
                desc = "Buffers",
            },
        },
        opts = function()
            local lga_actions = require("telescope-live-grep-args.actions")
            return {
                extensions = {
                    live_grep_args = {
                        mappings = {
                            i = {
                                ["<C-k>"] = lga_actions.quote_prompt(),
                                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            },
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("live_grep_args")
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
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = { use_diagnostic_signs = true },
        cmd = { "TroubleToggle", "Trouble" },
        keys = {
            {
                "<leader>xx",
                function()
                    require("trouble").toggle("document_diagnostics")
                end,
                desc = "Document Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                function()
                    require("trouble").toggle("workspace_diagnostics")
                end,
                desc = "Workspace Diagnostics (Trouble)",
            },
            {
                "<leader>xL",
                function()
                    require("trouble").toggle("loclist")
                end,
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                function()
                    require("trouble").toggle("quickfix")
                end,
                desc = "Quickfix List (Trouble)",
            },
        },
    },
}
