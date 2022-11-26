local lspconfig = require("lspconfig")
local navic = require("nvim-navic")
local null_ls = require("null-ls")
local utils = require("utils")
local coq = require("coq")

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
    signs = true,
    update_in_insert = false,
    severity_sort = false,
    float = { border = border },
})

-- Initialize capabilities with all the completions that `coq` can perform.
local capabilities = coq.lsp_ensure_capabilities().capabilities

-- Extend capabilities with folding functionality from 'nvim-ufo'
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

-- Buffer-local setup function
local function custom_lsp_attach(client, bufnr)
    local ts_builtin = require("telescope.builtin")

    -- Define buffer-local mapping
    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end
    local opts = {
        noremap = true,
        silent = true,
    }

    -- Find the client's capabilities
    local cap = client.server_capabilities

    -- Set up code-context plugin
    if cap.documentSymbolProvider then
        navic.attach(client, bufnr)
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
        map("n", "glcl", vim.lsp.codelens.run, opts)
    end

    -- Set up key mappings
    map({ "n", "v" }, "gla", vim.lsp.buf.code_action, opts)
    map("n", "gld", ts_builtin.lsp_definitions, opts)
    map("n", "glD", vim.lsp.buf.declaration, opts)
    map("n", "glf", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
    map("n", "glh", vim.lsp.buf.hover, opts)
    map("n", "glH", vim.lsp.buf.signature_help, opts)
    map("n", "gli", ts_builtin.lsp_implementations, opts)
    map("n", "glj", vim.diagnostic.goto_next, opts)
    map("n", "glk", vim.diagnostic.goto_prev, opts)
    map("n", "gln", vim.lsp.buf.rename, opts)
    map("n", "glr", ts_builtin.lsp_references, opts)
    map("n", "gltd", vim.lsp.buf.type_definition, opts)
    map("n", "glwd", ts_builtin.diagnostics, opts)
    map("n", "glwl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    map("n", "glws", ts_builtin.lsp_workspace_symbols, opts)
    map("n", "glx", function()
        vim.lsp.stop_client(vim.lsp.get_active_clients())
    end, opts)

    -- trouble.nvim
    map("n", "<leader>xx", "<Cmd>Trouble<CR>", opts)
    map("n", "<leader>xw", "<Cmd>Trouble lsp_workspace_diagnostics<CR>", opts)
    map("n", "<leader>xd", "<Cmd>Trouble lsp_document_diagnostics<CR>", opts)
    map("n", "<leader>xl", "<Cmd>Trouble loclist<CR>", opts)
    map("n", "<leader>xq", "<Cmd>Trouble quickfix<CR>", opts)
    map("n", "<leader>xr", "<Cmd>Trouble lsp_references<CR>", opts)
end

-- Enable/configure LSPs

local servers = {
    "clangd",
    "denols",
    "hls",
    "pyright",
}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
        on_attach = custom_lsp_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
    })
end

-- null-ls

null_ls.setup({
    sources = {
        -- Python code formatter
        null_ls.builtins.formatting.black,

        -- Code formatter for many languages, such as Markdown
        null_ls.builtins.formatting.prettier,

        -- Code formatter for shell scripts
        null_ls.builtins.formatting.shfmt.with({
            extra_args = { "-i", "4", "-bn", "-ci", "-sr" },
        }),

        -- Lua code formatter
        null_ls.builtins.formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces" },
        }),

        -- Linter for git commits
        null_ls.builtins.diagnostics.gitlint.with({
            extra_args = { "--ignore", "body-is-missing" },
        }),

        -- Linter for Dockerfiles
        null_ls.builtins.diagnostics.hadolint,

        -- Static analysis tool for shell scripts
        null_ls.builtins.diagnostics.shellcheck,
    },
    on_attach = custom_lsp_attach,
})

-- nvim-metals (Scala LSP)

local Path = require("plenary.path")

local metals = require("metals")
metals_config = metals.bare_config()
metals_config.on_attach = custom_lsp_attach
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
            auto = false,
        },
    },
    server = {
        on_attach = custom_lsp_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },

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
