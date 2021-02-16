local lspconfig = require'lspconfig'

local shared_diagnostic_settings = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {virtual_text = {prefix = ''}}
)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.util.default_config = vim.tbl_extend(
    'force',
    lspconfig.util.default_config,
    {
        handlers = {
            ['textDocument/publishDiagnostics'] = shared_diagnostic_settings,
        },
        on_attach = require'completion'.on_attach,
        capabilities = capabilities
    }
)

-- Enable/configure LSPs
lspconfig.clangd.setup{}

lspconfig.rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy"
            }
        }
    }
})

lspconfig.pyright.setup{}

lspconfig.hls.setup{}

-- nvim-metals (Scala LSP)
metals_config = require'metals'.bare_config
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = {'akka.actor.typed.javadsl', 'com.github.swagger.akka.javadsl'}
}

metals_config.on_attach = function()
  require'completion'.on_attach();
end

metals_config.init_options.statusBarProvider = 'on'
metals_config.handlers['textDocument/publishDiagnostics'] = shared_diagnostic_settings
metals_config.capabilities = capabilities

vim.cmd [[augroup lsp]]
vim.cmd [[autocmd!]]
vim.cmd [[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]]
vim.cmd [[augroup end]]
