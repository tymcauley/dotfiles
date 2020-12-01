-- lspconfig object
local lspconfig = require'lspconfig'

-- Enable/configure LSPs
lspconfig.clangd.setup{}

lspconfig.metals.setup{}

lspconfig.rust_analyzer.setup{}
