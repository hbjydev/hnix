local function init()
    local oxocarbon = require('oxocarbon')

    vim.api.nvim_set_hl(0, "IndentBlanklineIndent", { fg = oxocarbon.oxocarbon.base01 })
    vim.api.nvim_set_hl(0, "IndentBlanklineIndentActive", { fg = oxocarbon.oxocarbon.base03 })

    require('indent_blankline').setup {
        show_current_context = true,

        char_highlight_list = {
            "IndentBlanklineIndent",
        },

        context_highlight_list = {
            "IndentBlanklineIndentActive",
        }
    }
end

return { init = init }
