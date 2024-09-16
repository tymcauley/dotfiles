return {
    -- Collection of common configurations for the nvim LSP client
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- Completion for LSP
            "scalameta/nvim-metals", -- Metals plugin
        },
        opts = {
            -- Enable the builtin LSP inlay hints
            inlay_hints = {
                enabled = true,
            },
            -- LSP server settings
            servers = {
                clangd = {},
                denols = {},
                hls = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            format = { enable = false }, -- Use stylua instead
                            runtime = { version = "LuaJIT" },
                            diagnostics = { globals = { "vim" } }, -- Recognize the `vim` global
                            workspace = {
                                checkThirdParty = false,
                                library = vim.api.nvim_get_runtime_file("", true), -- Make server aware of nvim runtime files
                            },
                        },
                    },
                },
                pyright = {},
                typst_lsp = {},
                verible = {},
            },
        },
        config = function(_, opts)
            local servers = opts.servers
            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )

            -- Configure LSP servers
            for server, base_server_opts in pairs(servers) do
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, base_server_opts or {})
                require("lspconfig")[server].setup(server_opts)
            end

            -- Buffer-local setup function
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(args)
                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    -- Disable LSP formatting when running `gq` commands.
                    vim.bo.formatexpr = nil

                    -- Define buffer-local mapping
                    local function map(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                    end

                    -- Find the client's capabilities
                    local cap = client.server_capabilities

                    -- Set up code-context plugin
                    if cap.documentSymbolProvider then
                        require("nvim-navic").attach(client, bufnr)
                    end

                    -- Highlight the symbol under the cursor
                    if cap.documentHighlightProvider then
                        local lsp_highlight_cursor = vim.api.nvim_create_augroup("lsp_highlight_cursor", {})
                        vim.api.nvim_create_autocmd("CursorHold", {
                            callback = vim.lsp.buf.document_highlight,
                            buffer = bufnr,
                            group = lsp_highlight_cursor,
                        })
                        vim.api.nvim_create_autocmd("CursorMoved", {
                            callback = vim.lsp.buf.clear_references,
                            buffer = bufnr,
                            group = lsp_highlight_cursor,
                        })
                    end

                    -- Set up code lens support
                    if cap.code_lens then
                        local lsp_code_lens = vim.api.nvim_create_augroup("lsp_code_lens", {})
                        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                            callback = function()
                                vim.lsp.codelens.refresh()
                            end,
                            buffer = bufnr,
                            group = lsp_code_lens,
                        })
                        map("n", "<leader>ccl", vim.lsp.codelens.run, "Run code lens")
                    end

                    -- Set up inlay hints
                    if opts.inlay_hints.enabled and vim.lsp.inlay_hint then
                        map("n", "<leader>cth", function()
                            vim.lsp.inlay_hint.enable(
                                not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
                                { bufnr = bufnr }
                            )
                        end, "Toggle inlay hints")
                    end

                    local ts = require("telescope.builtin")

                    -- Set up mappings

                    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Run code action")
                    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
                    map("n", "<leader>cx", client.stop, "Stop client")

                    map("n", "gd", ts.lsp_definitions, "Go to definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("n", "K", vim.lsp.buf.hover, "Hover")
                    map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
                    map("n", "gI", ts.lsp_implementations, "Go to implementation")
                    map("n", "gr", ts.lsp_references, "Go to reference")
                    map("n", "gy", ts.lsp_type_definitions, "Go to t[y]pe definition")
                end,
            })
        end,
    },

    -- Render LSP diagnostics inline with code
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        name = "lsp_lines.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>ctl",
                function()
                    require("lsp_lines").toggle()
                end,
                desc = "Toggle lsp_lines",
            },
        },
        opts = {},
    },

    -- Display LSP status in standalone UI
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {},
    },

    -- Run standalone linters
    {
        "mfussenegger/nvim-lint",
        event = "VeryLazy",
        opts = {
            linters = {
                dockerfile = { "hadolint" },
                json = { "jq" },
                sh = { "shellcheck" },
                verilog = { "verilator" },
            },
        },
        config = function(_, opts)
            require("lint").linters_by_ft = opts.linters

            -- Run linter after writing.
            vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint()
                end,
            })
        end,
    },

    -- Run standalone code formatters, or LSP formatter
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        opts = {
            formatters_by_ft = {
                cmake = { "gersemi" },
                json = { "prettier" },
                lua = { "stylua" },
                python = { "ruff_format" },
                sh = { "shfmt" },
                yaml = { "prettier" },
            },
        },
        config = function(_, opts)
            require("conform").setup(opts)

            -- Use LSP formatter if available, otherwise use formatter configured here.
            vim.keymap.set("n", "<leader>cf", function()
                require("conform").format({
                    lsp_format = "prefer",
                    async = true,
                })
            end, { desc = "Format document" })

            -- Customize arguments passed to formatters.
            local util = require("conform.util")
            local shfmt = require("conform.formatters.shfmt")
            require("conform").formatters.shfmt = vim.tbl_deep_extend("force", shfmt, {
                args = util.extend_args(shfmt.args, { "-i", "4", "-bn", "-ci", "-sr" }),
            })
            local stylua = require("conform.formatters.stylua")
            require("conform").formatters.stylua = vim.tbl_deep_extend("force", stylua, {
                args = util.extend_args(stylua.args, { "--indent-type", "Spaces" }),
            })
        end,
    },

    -- rust-analyzer plugin
    {
        "mrcjkb/rustaceanvim",
        lazy = false, -- This plugin is already lazy
    },

    -- Metals plugin
    {
        "scalameta/nvim-metals",
        dependencies = "hrsh7th/cmp-nvim-lsp", -- Completion for LSP
        lazy = true,
        keys = {
            {
                "<leader>m",
                function()
                    require("metals").commands()
                end,
                desc = "Show metals commands",
            },
        },
        config = function()
            local metals_config = require("metals").bare_config()

            metals_config.settings = {
                enableSemanticHighlighting = true,
                excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
                inlayHints = {
                    hintsInPatternMatch = { enable = true },
                    implicitArguments = { enable = true },
                    implicitConversions = { enable = true },
                    inferredTypes = { enable = true },
                    typeParameters = { enable = true },
                },
            }

            metals_config.root_patterns = { "build.sbt", "build.sc" }

            -- Find the last directory which contains one of the files/directories in 'metals_config.root_patterns'.
            -- This ensures that Metals finds the highest-level root directory in a project with nested sub-projects.
            metals_config.find_root_dir = function(patterns, startpath)
                local Path = require("plenary.path")
                local root_dir = nil
                local path = Path:new(startpath)
                for _, parent in ipairs(path:parents()) do
                    for _, pattern in ipairs(patterns) do
                        local target = Path:new(parent, pattern)
                        if target:exists() then
                            root_dir = parent
                        end
                    end
                end
                return root_dir
            end

            local capabilities = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )

            metals_config.init_options.statusBarProvider = "on"
            metals_config.capabilities = capabilities
            metals_config.handlers = handlers

            local lsp_metals = vim.api.nvim_create_augroup("lsp_metals", {})
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "scala", "sbt" },
                callback = function()
                    require("metals").initialize_or_attach(metals_config)
                end,
                group = lsp_metals,
            })
        end,
    },

    -- Display code context from LSP
    {
        "SmiteshP/nvim-navic",
        event = "LspAttach",
    },
}
