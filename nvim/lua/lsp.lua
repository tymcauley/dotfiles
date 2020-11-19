-- lspconfig object
local lspconfig = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable/configure LSPs
lspconfig.clangd.setup({ on_attach=on_attach })

lspconfig.metals.setup({ on_attach=on_attach })

lspconfig.rust_analyzer.setup({ on_attach=on_attach })
