local function init()
  require('hbjy.plugins.telescope').init()
  require('hbjy.plugins.neotree').init()
  require('hbjy.plugins.lsp').init()
  require('hbjy.plugins.cmp').init()
end

return { init = init }
