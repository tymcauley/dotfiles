-- lspconfig object
local lspconfig = require'lspconfig'

-- Enable/configure LSPs
lspconfig.clangd.setup{}

lspconfig.rust_analyzer.setup{}

lspconfig.pyright.setup{}

lspconfig.hls.setup{}
