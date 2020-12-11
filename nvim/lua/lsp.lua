-- lspconfig object
local lspconfig = require'lspconfig'

-- Enable/configure LSPs
lspconfig.clangd.setup{}

lspconfig.rust_analyzer.setup{}

-- Provided by 'scalameta/nvim-metals' plugin
local metals       = require'metals'
local metals_setup = require'metals.setup'
lspconfig.metals.setup{
    on_attach    = metals_setup.auto_commands();
    root_dir     = metals.root_pattern("build.sbt", "build.sc", ".git");
    init_options = {
        inputBoxProvider             = true;
        quickPickProvider            = true;
        executeClientCommandProvider = true;
        decorationProvider           = true;
        didFocusProvider             = true;
    };

    handlers = {
        ["textDocument/hover"]          = metals['textDocument/hover'];
        ["metals/status"]               = metals['metals/status'];
        ["metals/inputBox"]             = metals['metals/inputBox'];
        ["metals/quickPick"]            = metals['metals/quickPick'];
        ["metals/executeClientCommand"] = metals["metals/executeClientCommand"];
        ["metals/publishDecorations"]   = metals["metals/publishDecorations"];
        ["metals/didFocusTextDocument"] = metals["metals/didFocusTextDocument"];
    };
}
