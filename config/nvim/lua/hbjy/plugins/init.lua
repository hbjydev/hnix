local function init()
  require('hbjy.plugins.telescope').init()
  require('hbjy.plugins.neotree').init()
  require('hbjy.plugins.lsp').init()
  require('hbjy.plugins.cmp').init()
  require('hbjy.plugins.copilot').init()
  require('hbjy.plugins.indent_blankline').init()
  require('hbjy.plugins.neorg').init()
  require('hbjy.plugins.rest').init()

  require 'todo-comments'.setup {}
  require 'gitsigns'.setup {}
end

return { init = init }
