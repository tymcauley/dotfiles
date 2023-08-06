return {
    -- Collection of common configurations for the nvim LSP client
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- Completion for LSP
            "lsp_lines.nvim", -- Render LSP diagnostics inline with code
            "j-hui/fidget.nvim", -- Display LSP status in standalone UI
            "simrat39/rust-tools.nvim", -- rust-analyzer plugin
            "scalameta/nvim-metals", -- Metals plugin
            "jose-elias-alvarez/null-ls.nvim", -- Connect non-LSP sources into nvim's LSP client
        },
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                virtual_text = false,
                virtual_lines = true,
                signs = true,
                update_in_insert = false,
                severity_sort = false,
            },
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
                verible = {},
            },
        },
        config = function(_, opts)
            -- Customize diagnostic symbols in the gutter
            local signs = { Error = "󰅚 ", Warn = " ", Hint = "󰌶 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end
            vim.diagnostic.config(opts.diagnostics)

            local servers = opts.servers
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

                    -- Set up code formatting
                    if client.supports_method("textDocument/formatting") then
                        -- Determine if this buffer has a formatting provider from null-ls.
                        local ft = vim.bo[bufnr].filetype
                        local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0
                        map("n", "<leader>cf", function()
                            vim.lsp.buf.format({
                                async = true,
                                filter = function(format_client)
                                    if have_nls then
                                        return format_client.name == "null-ls"
                                    end
                                    return format_client.name ~= "null-ls"
                                end,
                            })
                        end, "Format document")
                    end

                    -- Set up inlay hints
                    if opts.inlay_hints.enabled and vim.lsp.buf.inlay_hint then
                        if client.server_capabilities.inlayHintProvider then
                            vim.lsp.buf.inlay_hint(bufnr, true)
                        end
                        map("n", "<leader>cth", function()
                            vim.lsp.buf.inlay_hint(0, nil)
                        end, "Toggle inlay hints")
                    end

                    local fzf = require("fzf-lua")

                    -- Set up mappings

                    map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
                    map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")

                    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Run code action")
                    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
                    map("n", "<leader>cx", client.stop, "Stop client")

                    map("n", "gd", function()
                        fzf.lsp_definitions({
                            jump_to_single_result = true,
                        })
                    end, "Go to definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("n", "K", vim.lsp.buf.hover, "Hover")
                    map("n", "gK", vim.lsp.buf.signature_help, "Signature help")
                    map("n", "gI", fzf.lsp_implementations, "Go to implementation")
                    map("n", "gr", function()
                        fzf.lsp_references({
                            ignore_current_line = true,
                            jump_to_single_result = true,
                        })
                    end, "Go to reference")
                    map("n", "gy", vim.lsp.buf.type_definition, "Go to t[y]pe definition")
                end,
            })
        end,
    },

    -- Render LSP diagnostics inline with code
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        name = "lsp_lines.nvim",
        lazy = true,
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
        tag = "legacy",
        lazy = true,
        opts = {}, -- `opts = {}` is the same as calling `require("fidget").setup({})`
    },

    {
        "jose-elias-alvarez/null-ls.nvim",
        lazy = true,
        opts = function()
            local nls = require("null-ls")
            return {
                sources = {
                    nls.builtins.formatting.black, -- Python code formatter
                    nls.builtins.formatting.prettier.with({ -- Code formatter for many languages, such as Markdown
                        filetypes = { "json", "yaml" },
                    }),
                    nls.builtins.formatting.shfmt.with({ -- Code formatter for shell scripts
                        extra_args = { "-i", "4", "-bn", "-ci", "-sr" },
                    }),
                    nls.builtins.formatting.stylua.with({ -- Lua code formatter
                        extra_args = { "--indent-type", "Spaces" },
                    }),
                    nls.builtins.diagnostics.gitlint.with({ -- Linter for git commits
                        extra_args = { "--ignore", "body-is-missing" },
                    }),
                    nls.builtins.diagnostics.hadolint, -- Linter for Dockerfiles
                    nls.builtins.diagnostics.shellcheck, -- Static analysis tool for shell scripts
                },
            }
        end,
    },

    -- rust-analyzer plugin
    {
        "simrat39/rust-tools.nvim",
        dependencies = "hrsh7th/cmp-nvim-lsp", -- Completion for LSP
        lazy = true,
        opts = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            return {
                tools = {
                    inlay_hints = {
                        -- This is handled by builtin LSP
                        auto = false,
                    },
                },
                server = {
                    capabilities = capabilities,
                    -- TODO: When I enable this setting, all diagnostics disappear
                    -- settings = {
                    --     ["rust-analyzer"] = {
                    --         checkOnSave = {
                    --             command = "clippy",
                    --         },
                    --     },
                    -- },
                },
            }
        end,
    },

    -- Metals plugin
    {
        "scalameta/nvim-metals",
        dependencies = "hrsh7th/cmp-nvim-lsp", -- Completion for LSP
        lazy = true,
        config = function()
            local metals_config = require("metals").bare_config()

            metals_config.settings = {
                showImplicitArguments = true,
                excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
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

            -- Configure fidget.nvim with Metals.
            local metals_spinner_chars = {
                "⠋",
                "⠙",
                "⠸",
                "⠴",
                "⠦",
                "⠇",
            }
            -- Translate Metals status messages to a format that fidget.nvim can understand
            local function metals_status_handler(_, status, ctx)
                -- Strip off trailing spinner character (which is 3 characters wide)
                if status.text then
                    local maybe_spinner_char = status.text:sub(-3, -1)
                    for _, v in pairs(metals_spinner_chars) do
                        if v == maybe_spinner_char then
                            status.text = status.text:sub(1, -4)
                            break
                        end
                    end
                end

                -- https://github.com/scalameta/nvim-metals/blob/main/lua/metals/status.lua#L36-L50
                local val = {}
                if status.hide then
                    val = { kind = "end" }
                elseif status.show then
                    val = { kind = "begin", message = status.text, title = "Running" }
                elseif status.text then
                    val = { kind = "report", message = status.text }
                else
                    return
                end

                local info = { client_id = ctx.client_id }
                local msg = { token = "metals", value = val }
                -- call fidget progress handler
                vim.lsp.handlers["$/progress"](nil, msg, info)
            end
            local handlers = {}
            handlers["metals/status"] = metals_status_handler

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

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
    { "SmiteshP/nvim-navic", lazy = true },
}
