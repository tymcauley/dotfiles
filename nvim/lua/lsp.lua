local lspconfig = require'lspconfig'
local utils = require 'utils'

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
        capabilities = capabilities
    }
)

-- Buffer-local setup function
local function custom_lsp_attach(client, bufnr)
    -- Find the client's capabilities
    local cap = client.resolved_capabilities

    if cap.document_highlight then
        utils.create_augroup("LspHighlight", {
            {"CursorHold", "<buffer>", "lua vim.lsp.buf.document_highlight()"},
            {"CursorMoved", "<buffer>", "lua vim.lsp.buf.clear_references()"},
        })
    end
end

-- Enable/configure LSPs
lspconfig.clangd.setup { on_attach = custom_lsp_attach }

lspconfig.pyright.setup { on_attach = custom_lsp_attach }

lspconfig.hls.setup { on_attach = custom_lsp_attach }

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

vim.cmd [[augroup lsp]]
vim.cmd [[autocmd!]]
vim.cmd [[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(metals_config)]]
vim.cmd [[augroup end]]

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
        },

        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
              {"╭", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╮", "FloatBorder"},
              {"│", "FloatBorder"},
              {"╯", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╰", "FloatBorder"},
              {"│", "FloatBorder"}
            },
        }
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        on_attach = custom_lsp_attach,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                }
            }
        }
    }, -- rust-analyer options
}
