-- Haskell treesitter plugin uses C++11 features, but macOS clang doesn't enable those by default.
if vim.fn.has("mac") == 1 then
    require("nvim-treesitter.install").compilers = { "gcc-12" }
end

require("nvim-treesitter.configs").setup({
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
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "haskell",
        "help",
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
        "toml",
        "typescript",
        "verilog",
        "vim",
        "yaml",
    },
    highlight = { enable = true },
    rainbow = { enable = true },
})

-- Re-sync treesitter highlighting
vim.keymap.set("n", "<leader>tss", "<Cmd>write | edit | TSBufEnable highlight<CR>")
