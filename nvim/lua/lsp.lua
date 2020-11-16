-- lspconfig object
local lspconfig = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
lspconfig.rust_analyzer.setup({ on_attach=on_attach })
