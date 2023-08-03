local function init()
  require('hbjy.plugins.telescope').init()
  require('hbjy.plugins.neotree').init()
end

return { init = init }
