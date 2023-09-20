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
      ["core.integrations.telescope"] = {},
      ["core.presenter"] = {
        config = {
          zen_mode = "zen-mode",
        },
      },
    },
  }

  local neorg_callbacks = require("neorg.core.callbacks")

  ---@diagnostic disable-next-line: missing-parameter
  neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
      n = {   -- Bind keys in normal mode
        { "<C-s>", "core.integrations.telescope.find_linkable" },
      },

      i = {   -- Bind in insert mode
        { "<C-l>", "core.integrations.telescope.insert_link" },
      },
    }, {
      silent = true,
      noremap = true,
    })
  end)
end

return { init = init }
