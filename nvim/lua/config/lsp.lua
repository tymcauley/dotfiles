local lspconfig = require("lspconfig")

-- Customize diagnostic symbols in the gutter
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Default LSP settings

-- Customize border of floating windows
local border = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
}

-- Set how diagnostics are displayed
vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    virtual_lines = true,
    signs = true,
    update_in_insert = false,
    severity_sort = false,
    float = { border = border },
})

-- Initialize capabilities with all the completions that `nvim-cmp` can perform.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Buffer-local setup function
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- Define buffer-local mapping
        local opts = { buffer = bufnr }

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
            vim.keymap.set("n", "glcl", vim.lsp.codelens.run, opts)
        end

        -- Set up key mappings
        local fzf = require("fzf-lua")
        vim.keymap.set({ "n", "v" }, "gla", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gld", function()
            fzf.lsp_definitions({
                jump_to_single_result = true,
            })
        end, opts)
        vim.keymap.set("n", "glD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "glf", function()
            vim.lsp.buf.format({ async = true })
        end, opts)
        vim.keymap.set("n", "glh", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "glH", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "gli", fzf.lsp_implementations, opts)
        vim.keymap.set("n", "glj", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "glk", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "gln", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "glr", function()
            fzf.lsp_references({
                ignore_current_line = true,
                jump_to_single_result = true,
            })
        end, opts)
        vim.keymap.set("n", "gltd", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "glx", function()
            vim.lsp.stop_client(vim.lsp.get_active_clients())
        end, opts)
    end,
})

-- Enable/configure LSPs

local servers = {
    { "clangd", {} },
    { "denols", {} },
    { "hls", {} },
    {
        "lua_ls",
        {
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
    { "pyright", {} },
    { "verible", {} },
}
for _, lsp in ipairs(servers) do
    local lsp_name = lsp[1]
    local lsp_settings = lsp[2]
    lspconfig[lsp_name].setup({
        capabilities = capabilities,
        settings = lsp_settings,
    })
end

local nls = require("null-ls")
nls.setup({
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
})

-- nvim-metals (Scala LSP)

local Path = require("plenary.path")

local metals = require("metals")
metals_config = metals.bare_config()
metals_config.settings = {
    showImplicitArguments = true,
    excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}
metals_config.root_patterns = { "build.sbt", "build.sc" }

-- Find the last directory which contains one of the files/directories in 'metals_config.root_patterns'
metals_config.find_root_dir = function(patterns, startpath)
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

metals_config.init_options.statusBarProvider = "on"
metals_config.capabilities = capabilities
metals_config.handlers = handlers

local lsp_metals = vim.api.nvim_create_augroup("lsp_metals", {})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "scala,sbt",
    callback = function()
        metals.initialize_or_attach(metals_config)
    end,
    group = lsp_metals,
})

-- rust-tools (simrat39/rust-tools.nvim)

require("rust-tools").setup({
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
})
