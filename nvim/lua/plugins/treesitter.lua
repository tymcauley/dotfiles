return {
    -- Treesitter integration into neovim
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            -- Re-sync treesitter highlighting
            { "<leader>tss", "<Cmd>write | edit | TSBufEnable highlight<CR>", desc = "Re-sync treesitter" },
        },
        opts = function()
            -- Disable treesitter if the file is too large
            local disable_fn = function(_, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end

            return {
                ensure_installed = {
                    "bash",
                    "bibtex",
                    "c",
                    "cmake",
                    "comment",
                    "cpp",
                    "css",
                    "devicetree",
                    "diff",
                    "dockerfile",
                    "dot",
                    "firrtl",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                    "haskell",
                    "html",
                    "http",
                    "java",
                    "javascript",
                    "json",
                    "jsonc",
                    "lalrpop",
                    "latex",
                    "llvm",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "ninja",
                    "nix",
                    "perl",
                    "python",
                    "regex",
                    "rst",
                    "ruby",
                    "rust",
                    "scala",
                    "ssh_config",
                    "tablegen",
                    "toml",
                    "typescript",
                    "verilog",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                highlight = {
                    enable = true,
                    disable = disable_fn,
                },
            }
        end,
        config = function(_, opts)
            -- Haskell treesitter plugin uses C++11 features, but macOS clang doesn't enable those by default.
            if vim.fn.has("mac") == 1 then
                require("nvim-treesitter.install").compilers = { "gcc-13" }
            end

            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- Show code context with treesitter
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            max_lines = 3,
        },
    },
}
