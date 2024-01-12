local wezterm = require("wezterm")
local blend_hex = colorutils['blend-hex']

local is_dark = true

local function gsplit(text, pattern, plain)
  local splitStart, length = 1, #text
  return function ()
    if splitStart then
      local sepStart, sepEnd = string.find(text, pattern, splitStart, plain)
      local ret
      if not sepStart then
        ret = string.sub(text, splitStart)
        splitStart = nil
      elseif sepEnd < sepStart then
        -- Empty separator!
        ret = string.sub(text, splitStart, sepStart)
        if sepStart < length then
          splitStart = sepStart + 1
        else
          splitStart = nil
        end
      else
        ret = sepStart > splitStart and string.sub(text, splitStart, sepStart - 1) or ''
        splitStart = sepEnd + 1
      end
      return ret
    end
  end
end

local function split(text, pattern, plain)
  local ret = {}
  for match in gsplit(text, pattern, plain) do
    table.insert(ret, match)
  end
  return ret
end

local base00 = "#161616"
local base06 = "#ffffff"
local base09 = "#78a9ff"
local oxocarbon = {
    dark = {
        base00 = base00,
        base01 = blend_hex(base00, base06, 0.085),
        base02 = blend_hex(base00, base06, 0.18),
        base03 = blend_hex(base00, base06, 0.3),
        base04 = blend_hex(base00, base06, 0.82),
        base05 = blend_hex(base00, base06, 0.95),
        base06 = base06,
        base07 = "#08bdba",
        base08 = "#3ddbd9",
        base09 = base09,
        base10 = "#ee5396",
        base11 = "#33b1ff",
        base12 = "#ff7eb6",
        base13 = "#42be65",
        base14 = "#be95ff",
        base15 = "#82cfff",
        blend = "#131313",
        none = "NONE"
    },
    light = {
        base00 = base06,
        base01 = blend_hex(base00, base06, 0.95),
        base02 = blend_hex(base00, base06, 0.82),
        base03 = base00,
        base04 = "#37474F",
        base05 = "#90A4AE",
        base06 = "#525252",
        base07 = "#08bdba",
        base08 = "#ff7eb6",
        base09 = "#ee5396",
        base10 = "#FF6F00",
        base11 = "#0f62fe",
        base12 = "#673AB7",
        base13 = "#42be65",
        base14 = "#be95ff",
        base15 = "#FFAB91",
        blend = "#FAFAFA",
        none = "NONE"
    }
}

local colors = is_dark and oxocarbon.dark or oxocarbon.light

local function get_process(tab)
	local process_icons = {
        ["irssi"] = {
            { Foreground = { Color = colors.base12 } },
            { Text = wezterm.nerdfonts.fa_hashtag },
        },
		["docker"] = {
			{ Foreground = { Color = colors.base11 } },
			{ Text = wezterm.nerdfonts.linux_docker },
		},
		["docker-compose"] = {
			{ Foreground = { Color = colors.base11 } },
			{ Text = wezterm.nerdfonts.linux_docker },
		},
		["nvim"] = {
			{ Foreground = { Color = colors.base13 } },
			{ Text = wezterm.nerdfonts.custom_vim },
		},
		["vim"] = {
			{ Foreground = { Color = colors.base13 } },
			{ Text = wezterm.nerdfonts.dev_vim },
		},
		["node"] = {
			{ Foreground = { Color = colors.base13 } },
			{ Text = wezterm.nerdfonts.mdi_hexagon },
		},
		["zsh"] = {
			{ Foreground = { Color = colors.base12 } },
			{ Text = wezterm.nerdfonts.dev_terminal },
		},
		["bash"] = {
			{ Foreground = { Color = colors.base02 } },
			{ Text = wezterm.nerdfonts.cod_terminal_bash },
		},
		["cargo"] = {
			{ Foreground = { Color = colors.base10 } },
			{ Text = wezterm.nerdfonts.dev_rust },
		},
		["go"] = {
			{ Foreground = { Color = colors.base08 } },
			{ Text = wezterm.nerdfonts.mdi_language_go },
		},
		["lazydocker"] = {
			{ Foreground = { Color = colors.base11 } },
			{ Text = wezterm.nerdfonts.linux_docker },
		},
		["git"] = {
			{ Foreground = { Color = colors.base12 } },
			{ Text = wezterm.nerdfonts.dev_git },
		},
		["lazygit"] = {
			{ Foreground = { Color = colors.base12 } },
			{ Text = wezterm.nerdfonts.dev_git },
		},
		["lua"] = {
			{ Foreground = { Color = colors.base11 } },
			{ Text = wezterm.nerdfonts.seti_lua },
		},
		["gh"] = {
			{ Foreground = { Color = colors.base14 } },
			{ Text = wezterm.nerdfonts.dev_github_badge },
		},
        ["python"] = {
            { Foreground = { Color = colors.base15 } },
            { Text = wezterm.nerdfonts.mdi_language_python },
        },
	}

	local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

    if string.find(process_name, "python3.") or string.find(process_name, "python3") then
        process_name = "python"
    end

	return wezterm.format(
		process_icons[process_name] or
        {
            { Foreground = { Color = colors.base04 } },
            { Text = string.format("[%s]", process_name) }
        }
	)
end

local function get_current_working_dir(tab)
	local current_dir = tab.active_pane.current_working_dir
	local homedir = string.format("file://hayden-pc%s/", os.getenv("HOME"))

    if current_dir == homedir then
        return "  ~"
    else
        local chunks = split(current_dir, '/', true)
        local pathname = chunks[#chunks - 1]

        local path = string.format("  %s", pathname)
        return path
    end
end

wezterm.on("format-tab-title", function(tab)
	return wezterm.format({
		{ Attribute = { Intensity = "Half" } },
		{ Text = string.format(" %s  ", tab.tab_index + 1) },
		"ResetAttributes",
		{ Text = get_process(tab) },
		{ Text = " " },
		{ Text = get_current_working_dir(tab) },
		{ Foreground = { Color = colors.base01 } },
		{ Text = "  ▕" },
	})
end)

wezterm.on("update-right-status", function(window)
	window:set_right_status(wezterm.format({
		{ Text = wezterm.strftime("   %Y-%m-%d %H:%M:%S ") },
	}))
end)

return {
  default_cursor_style = "SteadyBar",

  enable_kitty_graphics = true,
  term = "wezterm",

  max_fps = 120,

  font = wezterm.font("IntoneMono Nerd Font"),
  font_size = 12,

  audible_bell = "Disabled",

  enable_tab_bar = true,
  enable_wayland = false,

  window_background_opacity = 0.85,
  window_close_confirmation = "NeverPrompt",
  window_decorations = "RESIZE",
  window_padding = {
      left = 16,
      right = 16,
      top = 16,
      bottom = 16,
  },

  initial_cols = 110,
  initial_rows = 25,

  default_prog = { "zsh" },

  enable_scroll_bar = false,
  tab_bar_at_bottom = false,
  use_fancy_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  tab_max_width = 50,
  hide_tab_bar_if_only_one_tab = true,

  colors = {
    tab_bar = {
      background = colors.base00,

      active_tab = {
          bg_color = colors.base01,
          fg_color = colors.base04,
          intensity = 'Bold',
      },

      inactive_tab = {
          bg_color = colors.base00,
          fg_color = colors.base03,
      },
    },

    background = colors.base00,

    cursor_bg = colors.base04,
    cursor_fg = colors.base02,

    selection_fg = colors.base05,
    selection_bg = colors.base03,

    scrollbar_thumb = "#222222",

    split = "#444444",

    ansi = {
      colors.base02,
      colors.base12,
      colors.base13,
      colors.base15,
      colors.base11,
      colors.base10,
      colors.base08,
      colors.base04,
    },

    brights = {
      colors.base02,
      colors.base12,
      colors.base13,
      colors.base15,
      colors.base11,
      colors.base10,
      colors.base08,
      colors.base05,
    },
  },

  hyperlink_rules = {
    {
      regex = "\\b\\w+://[\\w.-]+:[0-9]{2,15}\\S*\\b",
      format = "$0",
    },
    {
      regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
      format = "$0",
    },
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = "mailto:$0",
    },
    {
      regex = [[\bfile://\S*\b]],
      format = "$0",
    },
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = "$0",
    },
    {
      regex = [[\b[tT](\d+)\b]],
      format = "https://example.com/tasks/?t=$1",
    },
  },
}
