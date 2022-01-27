local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local utils = require("utils")

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

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Extend default capabilities with everything 'nvim-cmp' can do
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Buffer-local setup function
local function custom_lsp_attach(client, bufnr)
    local tsb = require("telescope.builtin")

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

    -- Show diagnostics under the cursor
    utils.create_augroup("LspDiagnosticCursor", {
        {
            "CursorHold,CursorHoldI",
            "<buffer>",
            "lua vim.diagnostic.open_float(nil, { focus=false, scope='cursor' })",
        },
    })

    -- Find the client's capabilities
    local cap = client.resolved_capabilities

    -- Highlight the symbol under the cursor
    if cap.document_highlight then
        utils.create_augroup("LspHighlightCursor", {
            { "CursorHold", "<buffer>", "lua vim.lsp.buf.document_highlight()" },
            { "CursorMoved", "<buffer>", "lua vim.lsp.buf.clear_references()" },
        })
    end

    -- Set up key mappings
    map("n", "gla", tsb.lsp_code_actions, opts)
    map("v", "gla", tsb.lsp_range_code_actions, opts)
    map("n", "gld", tsb.lsp_definitions, opts)
    map("n", "glD", vim.lsp.buf.declaration, opts)
    map("n", "glf", vim.lsp.buf.formatting, opts)
    map("n", "glh", vim.lsp.buf.hover, opts)
    map("n", "glH", vim.lsp.buf.signature_help, opts)
    map("n", "gli", tsb.lsp_implementations, opts)
    map("n", "glj", vim.diagnostic.goto_next, opts)
    map("n", "glk", vim.diagnostic.goto_prev, opts)
    map("n", "gln", vim.lsp.buf.rename, opts)
    map("n", "glr", tsb.lsp_references, opts)
    map("n", "gltd", vim.lsp.buf.type_definition, opts)
    map("n", "glwd", tsb.diagnostics, opts)
    map("n", "glwl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    map("n", "glws", tsb.lsp_workspace_symbols, opts)
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

metals_config = require("metals").bare_config()
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

metals_config.init_options.statusBarProvider = "on"
metals_config.capabilities = capabilities

utils.create_augroup("LspMetals", {
    { "FileType", "scala,sbt", 'lua require("metals").initialize_or_attach(metals_config)' },
})

-- rust-tools (simrat39/rust-tools.nvim)

require("rust-tools").setup({
    tools = { -- rust-tools options
        inlay_hints = {
            -- prefix for parameter hints
            parameter_hints_prefix = "<- ",

            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = "=> ",

            -- whether to align to the length of the longest line in the file
            max_len_align = false,

            -- whether to align to the extreme right or not
            right_align = false,

            -- the highlight color of the hints
            highlight = "NonText",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        on_attach = custom_lsp_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    }, -- rust-analyer options
})
