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
            -- LSP server settings
            servers = {
                clangd = {},
                denols = {},
                hls = {},
                lua_ls = {
                    settings = {
                        Lua = {
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
            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
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
                    local map_opts = { buffer = bufnr }

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
                        vim.keymap.set("n", "glcl", vim.lsp.codelens.run, map_opts)
                    end

                    -- Set up code formatting
                    if client.supports_method("textDocument/formatting") then
                        -- Determine if this buffer has a formatting provider from null-ls.
                        local ft = vim.bo[bufnr].filetype
                        local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0
                        vim.keymap.set("n", "glf", function()
                            vim.lsp.buf.format({
                                async = true,
                                filter = function(format_client)
                                    if have_nls then
                                        return format_client.name == "null-ls"
                                    end
                                    return format_client.name ~= "null-ls"
                                end,
                            })
                        end, map_opts)
                    end

                    -- Set up key mappings
                    local fzf = require("fzf-lua")
                    vim.keymap.set({ "n", "v" }, "gla", vim.lsp.buf.code_action, map_opts)
                    vim.keymap.set("n", "gld", function()
                        fzf.lsp_definitions({
                            jump_to_single_result = true,
                        })
                    end, map_opts)
                    vim.keymap.set("n", "glD", vim.lsp.buf.declaration, map_opts)
                    vim.keymap.set("n", "glf", function()
                        vim.lsp.buf.format({ async = true })
                    end, map_opts)
                    vim.keymap.set("n", "glh", vim.lsp.buf.hover, map_opts)
                    vim.keymap.set("n", "glH", vim.lsp.buf.signature_help, map_opts)
                    vim.keymap.set("n", "gli", fzf.lsp_implementations, map_opts)
                    vim.keymap.set("n", "glj", vim.diagnostic.goto_next, map_opts)
                    vim.keymap.set("n", "glk", vim.diagnostic.goto_prev, map_opts)
                    vim.keymap.set("n", "gln", vim.lsp.buf.rename, map_opts)
                    vim.keymap.set("n", "glr", function()
                        fzf.lsp_references({
                            ignore_current_line = true,
                            jump_to_single_result = true,
                        })
                    end, map_opts)
                    vim.keymap.set("n", "gltd", vim.lsp.buf.type_definition, map_opts)
                    vim.keymap.set("n", "glx", function()
                        vim.lsp.stop_client(vim.lsp.get_active_clients())
                    end, map_opts)
                end,
            })
        end,
    },

    -- Render LSP diagnostics inline with code
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        name = "lsp_lines.nvim",
        lazy = true,
        config = function()
            require("lsp_lines").setup()
            vim.keymap.set("n", "<leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
        end,
    },

    -- Display LSP status in standalone UI
    {
        "j-hui/fidget.nvim",
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
                        filetypes = { "yaml" },
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
                        -- This is handled by lvimuser/lsp-inlayhints.nvim
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

    -- Display LSP inlay hints
    {
        "lvimuser/lsp-inlayhints.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("lsp-inlayhints").setup()
            vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                group = "LspAttach_inlayhints",
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end

                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    require("lsp-inlayhints").on_attach(client, bufnr, false)
                end,
            })
        end,
    },
}
