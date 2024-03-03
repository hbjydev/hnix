{ pkgs, ... }:
let
  oxocarbon = (import ../oxocarbon.nix).dark;
in
{
  programs.kitty = {
    enable = true;

    font = {
      name = "IntoneMono Nerd Font";
      package = pkgs.nerdfonts.override {
        fonts = [ "IntelOneMono" ];
      };
      size = 14;
    };

    keybindings = {
      "ctrl+shift+]" = "next_tab";
      "ctrl+shift+[" = "previous_tab";

      "ctrl+shift+t" = "launch --cwd=current --type=tab";
      "cmd+t" = "launch --cwd=current --type=tab";

      "ctrl+shift+enter" = "launch --cwd=current --location split";
      "cmd+enter" = "launch --cwd=current --location split";

      "alt+left" = "send_text all \\x1b\\x62";
      "alt+right" = "send_text all \\x1b\\x66";

      "ctrl+shift+up" = "neighboring_window up";
      "cmd+up" = "neighboring_window up";
      "ctrl+shift+left" = "neighboring_window left";
      "cmd+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "cmd+right" = "neighboring_window right";
      "ctrl+shift+down" = "neighboring_window down";
      "cmd+down" = "neighboring_window down";
    };

    settings = {
      allow_remote_control = "yes";
      enabled_layouts = "splits";
      hide_window_decorations = "titlebar-and-corners";
      listen_on = "unix:/tmp/kitty";
      macos_option_as_alt = "right";
      macos_quit_when_last_window_closed = "yes";
      macos_titlebar_color = "system";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      wayland_titlebar_color = "system";
      background_opacity = "0.9";
      draw_minimal_borders = "yes";
      window_padding_width = "16";

      tab_title_template = "{title}";

      # Oxocarbon
      background              = oxocarbon.base00;
      foreground              = oxocarbon.base05;
      selection_background    = oxocarbon.base05;
      selection_foreground    = oxocarbon.base00;
      url_color               = oxocarbon.base04;
      cursor                  = oxocarbon.base05;
      active_border_color     = oxocarbon.base03;
      inactive_border_color   = oxocarbon.base01;
      active_tab_background   = oxocarbon.base00;
      active_tab_foreground   = oxocarbon.base05;
      inactive_tab_background = oxocarbon.base01;
      inactive_tab_foreground = oxocarbon.base04;
      tab_bar_background      = oxocarbon.base01;

      # Normal
      color0 = oxocarbon.base00;
      color1 = oxocarbon.base08;
      color2 = oxocarbon.base0B;
      color3 = oxocarbon.base0A;
      color4 = oxocarbon.base0D;
      color5 = oxocarbon.base0E;
      color6 = oxocarbon.base0C;
      color7 = oxocarbon.base05;

      # Bright
      color8 = oxocarbon.base03;
      color9 = oxocarbon.base09;
      color10 = oxocarbon.base01;
      color11 = oxocarbon.base02;
      color12 = oxocarbon.base04;
      color13 = oxocarbon.base06;
      color14 = oxocarbon.base0F;
      color15 = oxocarbon.base07;
    };
  };
}
