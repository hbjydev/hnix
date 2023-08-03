local function init()
  require('neo-tree').setup {
    window = { position = "right" }
  }
end

return { init = init }
