return {
    -- Treesitter integration into neovim
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        opts = function()
            return {
                -- Ensure these treesitter parsers are installed
                ensure_installed = {
                    "asm",
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
                    "fish",
                    "git_config",
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
                    "lalrpop",
                    "latex",
                    "linkerscript",
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
                    "systemverilog",
                    "tablegen",
                    "tcl",
                    "toml",
                    "typescript",
                    "typst",
                    "vim",
                    "vimdoc",
                    "xml",
                    "yaml",
                },
                -- Don't enable treesitter indentation for these filetypes
                fts_disable_indent = {
                    "scala",
                },
            }
        end,
        config = function(_, opts)
            -- Only install the parsers that aren't already installed.
            local already_installed = require("nvim-treesitter.config").get_installed("parsers")
            local parsers_to_install = vim.iter(opts.ensure_installed)
                :filter(function(parser)
                    return not vim.tbl_contains(already_installed, parser)
                end)
                :totable()
            require("nvim-treesitter").install(parsers_to_install)

            -- The systemverilog parser covers plain Verilog too, register it for both filetypes.
            vim.treesitter.language.register("systemverilog", "verilog")

            -- Auto-start parsers for any buffer
            vim.api.nvim_create_autocmd("FileType", {
                desc = "Enable Treesitter",
                callback = function(event)
                    local bufnr = event.buf
                    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

                    -- Skip if no filetype
                    if filetype == "" then
                        return
                    end

                    -- Get parser name based on filetype
                    local parser_name = vim.treesitter.language.get_lang(filetype)
                    if not parser_name then
                        return
                    end

                    -- Start treesitter for this buffer. This is the only reliable way to tell whether a parser is
                    -- actually installed and usable: vim.treesitter.get_parser can return successfully even when no
                    -- parser is installed, deferring the failure to vim.treesitter.start.
                    local started = pcall(vim.treesitter.start, bufnr, parser_name)
                    if not started then
                        vim.notify(
                            "No treesitter parser for filetype '" .. filetype .. "' (language '" .. parser_name .. "')",
                            vim.log.levels.INFO
                        )
                        return
                    end
                    -- Use regex based syntax-highlighting as fallback as some plugins might need it
                    vim.bo[bufnr].syntax = "ON"
                    -- Use treesitter for folds
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo.foldtext = "v:lua.vim.treesitter.foldtext()"
                    -- Use treesitter for indentation if the filetype isn't in `opts.fts_disable_indent`.
                    local use_treesitter_indent = true
                    for _, ft_disable_indent in pairs(opts.fts_disable_indent) do
                        if ft_disable_indent == filetype then
                            use_treesitter_indent = false
                            break
                        end
                    end
                    if use_treesitter_indent then
                        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
}
