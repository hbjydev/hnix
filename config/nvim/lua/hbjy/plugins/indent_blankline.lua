local function init()
  local oxocarbon = require('oxocarbon')

  vim.api.nvim_set_hl(0, "IndentBlanklineIndent", { fg = oxocarbon.oxocarbon.base01 })
  vim.api.nvim_set_hl(0, "IndentBlanklineIndentActive", { fg = oxocarbon.oxocarbon.base03 })

  require('ibl').setup {
    indent = {
      highlight = "IndentBlanklineIndent",
      smart_indent_cap = true,
    },
  }
end

return { init = init }
