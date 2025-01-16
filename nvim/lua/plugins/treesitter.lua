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
                    "typst",
                    "verilog",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                highlight = {
                    enable = true,
                },
            }
        end,
        config = function(_, opts)
            -- Haskell treesitter plugin uses C++11 features, but macOS clang doesn't enable those by default.
            if vim.fn.has("mac") == 1 then
                require("nvim-treesitter.install").compilers = { "gcc-14" }
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
