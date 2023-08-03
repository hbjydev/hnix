local function init()
  require('hbjy.vim').init()
  require('hbjy.plugins').init()
  require('hbjy.statusline').init()
  require('hbjy.remap').init()
end

return { init = init }
