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
                    "jsonc",
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
                        vim.notify(
                            vim.inspect("No treesitter parser found for filetype: " .. filetype),
                            vim.log.levels.WARN
                        )
                        return
                    end

                    -- Try to get existing parser
                    local parser_configs = require("nvim-treesitter.parsers")
                    if not parser_configs[parser_name] then
                        return -- Parser not available, skip silently
                    end

                    local parser_exists = pcall(vim.treesitter.get_parser, bufnr, parser_name)
                    if not parser_exists then
                        -- Check if parser is already installed
                        if not vim.tbl_contains(already_installed, parser_name) then
                            -- If not installed, warn user and exit before trying to start treesitter
                            vim.notify("Treesitter parser not installed for " .. parser_name, vim.log.levels.WARN)
                            return
                        end
                    end

                    -- Start treesitter for this buffer
                    -- vim.notify(
                    --     vim.inspect("Starting treesitter parser '" .. parser_name .. "' for filetype: " .. filetype),
                    --     vim.log.levels.WARN
                    -- )
                    vim.treesitter.start(bufnr, parser_name)
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
