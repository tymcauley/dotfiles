local lspconfig = require('lspconfig')
local utils = require('utils')
local lsp_status = require('lsp-status')

-- Register the progress handler, so we can print LSP server progress messages
-- in the statusline.
lsp_status.register_progress()

-- Customize diagnostic symbols in the gutter
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Default LSP settings

local border = {
    {"╭", "FloatBorder"},
    {"─", "FloatBorder"},
    {"╮", "FloatBorder"},
    {"│", "FloatBorder"},
    {"╯", "FloatBorder"},
    {"─", "FloatBorder"},
    {"╰", "FloatBorder"},
    {"│", "FloatBorder"},
}

local shared_diagnostic_settings = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {virtual_text = {prefix = "■ "}}
)
local shared_hover_settings = vim.lsp.with(
    vim.lsp.handlers.hover,
    {border = border}
)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Extend default capabilities with 'window/workDoneProgress'
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

lspconfig.util.default_config = vim.tbl_extend(
    'force',
    lspconfig.util.default_config,
    {
        handlers = {
            ['textDocument/publishDiagnostics'] = shared_diagnostic_settings,
            ['textDocument/hover']              = shared_hover_settings,
            ['textDocument/signatureHelp']      = shared_hover_settings,
        },
        capabilities = capabilities
    }
)

-- Buffer-local setup function
local function custom_lsp_attach(client, bufnr)
    -- Find the client's capabilities
    local cap = client.resolved_capabilities

    -- Setup LSP highlighting
    if cap.document_highlight then
        utils.create_augroup("LspHighlight", {
            {"CursorHold", "<buffer>", "lua vim.lsp.buf.document_highlight()"},
            {"CursorMoved", "<buffer>", "lua vim.lsp.buf.clear_references()"},
        })
    end

    -- Shortcut for using telescope as the picker
    local function telescope(picker)
        return string.format("<Cmd>lua require('telescope.builtin').%s()<CR>", picker)
    end

    -- Setup key mappings
    utils.map('n', 'gla',  telescope('lsp_code_actions'),                                           {silent = true})
    utils.map('v', 'gla',  telescope('lsp_range_code_actions'),                                     {silent = true})
    utils.map('n', 'gld',  telescope('lsp_definitions'),                                            {silent = true})
    utils.map('n', 'glD',  '<Cmd>lua vim.lsp.buf.declaration()<CR>',                                {silent = true})
    utils.map('n', 'glf',  '<Cmd>lua vim.lsp.buf.formatting()<CR>',                                 {silent = true})
    utils.map('n', 'glh',  '<Cmd>lua vim.lsp.buf.hover()<CR>',                                      {silent = true})
    utils.map('n', 'glH',  '<Cmd>lua vim.lsp.buf.signature_help()<CR>',                             {silent = true})
    utils.map('n', 'gli',  telescope('lsp_implementations'),                                        {silent = true})
    utils.map('n', 'glj',  '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>',                           {silent = true})
    utils.map('n', 'glk',  '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',                           {silent = true})
    utils.map('n', 'gln',  '<Cmd>lua vim.lsp.buf.rename()<CR>',                                     {silent = true})
    utils.map('n', 'glr',  telescope('lsp_references'),                                             {silent = true})
    utils.map('n', 'gltd', '<Cmd>lua vim.lsp.buf.type_definition()<CR>',                            {silent = true})
    utils.map('n', 'glwl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', {silent = true})
    utils.map('n', 'glws', telescope('lsp_workspace_symbols'),                                      {silent = true})
    utils.map('n', 'glx',  '<Cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR>',        {silent = true})

    -- Register client for messages and set up buffer autocommands to update
    -- the statusline and the current function.
    lsp_status.on_attach(client)
end

-- Enable/configure LSPs

local servers = { "clangd", "pyright", "hls" }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = custom_lsp_attach,
        flags = {
            debounce_text_changes = 150,
        }
    }
end

-- nvim-metals (Scala LSP)

metals_config = require'metals'.bare_config
metals_config.on_attach = custom_lsp_attach
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = {'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl'}
}

metals_config.init_options.statusBarProvider = 'on'
metals_config.handlers['textDocument/publishDiagnostics'] = shared_diagnostic_settings
metals_config.capabilities = capabilities

utils.create_augroup("LspMetals", {
    {"FileType", "scala,sbt", "lua require(\"metals\").initialize_or_attach(metals_config)"},
})

-- rust-tools (simrat39/rust-tools.nvim)

require'rust-tools'.setup {
    tools = { -- rust-tools options
        inlay_hints = {
            -- prefix for parameter hints
            parameter_hints_prefix = "<- ",

            -- prefix for all the other hints (type, chaining)
            other_hints_prefix  = "=> ",

            -- whether to align to the length of the longest line in the file
            max_len_align = false,

            -- whether to align to the extreme right or not
            right_align = false,

            -- the highlight color of the hints
            highlight = "Comment",
        },

        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = border,
        }
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        on_attach = custom_lsp_attach,
        flags = {
            debounce_text_changes = 150,
        },
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                }
            }
        }
    }, -- rust-analyer options
}
