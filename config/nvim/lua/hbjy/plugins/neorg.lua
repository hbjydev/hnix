local function init()
  require("neorg").setup {
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {},
      ["core.dirman"] = {
        config = {
          workspaces = {
            personal = "~/Development/notes/personal",
            work = "~/Development/notes/work",
          },
          default_workspace = "personal",
        },
      },
    },
  }
end

return { init = init }
