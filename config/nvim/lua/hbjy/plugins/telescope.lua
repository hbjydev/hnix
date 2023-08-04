local function init()
  require('telescope').setup {
    pickers = {
      buffers = {
        show_all_buffers = true,
        sort_lastused = true,
        previewer = false,
        mappings = {
          i = { ["<c-d>"] = "delete_buffer" },
        },
      },
    },

    defaults = {
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      sorting_strategy = "ascending",

      layout_strategy = "flex",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
        },
        vertical = { mirror = false },
        width = 0.87,
        height = 0.8,
        preview_cutoff = 120,
      },

      dynamic_preview_title = true,

      set_env = {
        COLORTERM = "truecolor",
      },

      file_ignore_patterns = {
        "node_modules",
        ".direnv",
        "venv",
        "vendor",
      },
    },

    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
    },
  }

  require("telescope").load_extension("ui-select")
end

return { init = init }
