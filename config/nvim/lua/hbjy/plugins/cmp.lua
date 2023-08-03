local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function init()
    local cmp = require("cmp")

    local cmp_sources = {
        { name = "nvim_lsp", group_index = 1 },
        { name = "nvim_lsp_signature_help", group_index = 1 },
        { name = "buffer", group_index = 3 },
        { name = "path", group_index = 3 },
    }

    local snippet_expander = function(_)
        print("TODO!")
    end

    local can_expand = function()
        print("TODO!")
    end

    local expand = function()
        print("TODO!")
    end

    local can_jump_back = function()
        print("TODO!")
    end

    local jump_back = function()
        print("TODO!")
    end

    local icons = {
        Text = "  ",
        Method = "  ",
        Function = "  ",
        Constructor = "  ",
        Field = "  ",
        Variable = "  ",
        Class = "  ",
        Interface = "  ",
        Module = "  ",
        Property = "  ",
        Unit = "  ",
        Value = "  ",
        Enum = "  ",
        Keyword = "  ",
        Snippet = "  ",
        Color = "  ",
        File = "  ",
        Reference = "  ",
        Folder = "  ",
        EnumMember = "  ",
        Constant = "  ",
        Struct = "  ",
        Event = "  ",
        Operator = "  ",
        TypeParameter = "  ",
    }

    cmp.setup({
        experimental = { ghost_text = true },
        window = {
            documentation = { border = "solid" },
            completion = {
                col_offset = -3,
                side_padding = 0,
            },
        },
        preselect = cmp.PreselectMode.None,
        snippet = {
            expand = snippet_expander,
        },
        mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),

            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),

            ["<C-Space>"] = cmp.mapping.complete({}),
            ["<C-e>"] = cmp.mapping.close(),

            ["<C-y>"] = cmp.mapping.confirm(),

            ["<Tab>"] = cmp.mapping(function(fallback)
                if can_expand() then
                    expand()
                elseif has_words_before() then
                   cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function()
                if can_jump_back() then
                    jump_back()
                end
            end, { "i", "s" }),
        },
        sources = cmp_sources,
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(_, vim_item)
                vim_item.menu = vim_item.kind
                vim_item.kind = icons[vim_item.kind]
                return vim_item
            end,
        },
    })

    vim.o.completeopt = "menu,menuone,noselect"
end

return { init = init }
