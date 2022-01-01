-- Haskell treesitter plugin uses C++11 features, but macOS clang doesn't enable those by default.
if vim.fn.has("mac") == 1 then
    require("nvim-treesitter.install").compilers = { "gcc-11" }
end

require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    highlight = { enable = true },
    rainbow = { enable = true },
})
