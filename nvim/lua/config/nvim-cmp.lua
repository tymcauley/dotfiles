local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },

    mapping = {
        ["<C-n>"] = cmp.mapping({
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif vim.fn["vsnip#available"](1) == 1 then
                    feedkey("<Plug>(vsnip-expand-or-jump)", "")
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end,
        }),

        ["<C-p>"] = cmp.mapping({
            c = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
            i = function()
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                    feedkey("<Plug>(vsnip-jump-prev)", "")
                end
            end,
        }),

        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "c", "i" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "c", "i" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "c", "i" }),
        ["<C-e>"] = cmp.mapping({
            c = cmp.mapping.close(),
            i = cmp.mapping.abort(),
        }),
        ["<CR>"] = cmp.mapping({
            c = function(fallback)
                if cmp.visible() then
                    cmp.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    })
                else
                    fallback()
                end
            end,
            i = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            }),
        }),
    },

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "nvim_lsp_signature_help" },
    }, {
        { name = "nvim_lua" },
        { name = "buffer" },
        { name = "path" },
        { name = "calc" },
    }),

    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = "",
                buffer = "",
            })[entry.source.name]
            vim_item.kind = ({
                Text = "",
                Method = "",
                Function = "",
                Constructor = "",
                Field = "",
                Variable = "",
                Class = "",
                Interface = "ﰮ",
                Module = "",
                Property = "",
                Unit = "",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "﬌",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "ﬦ",
                TypeParameter = "",
            })[vim_item.kind] .. " " .. vim_item.kind
            return vim_item
        end,
    },
})

cmp.setup.cmdline("/", {
    sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" },
    }),
})
