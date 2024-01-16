{ inputs, work }:

{ pkgs, ... }:

let
  oxocarbon = (import ../shared/oxocarbon.nix).dark;
  shared-config = import ../shared/home-manager.nix { inherit inputs work; };
  shared-packages = import ../shared/home-manager-packages.nix { inherit pkgs inputs work; };
in
{
  imports = [ shared-config ];

  home.file."Library/Application Support/k9s/skin.yml".source = ../../config/k9s/skin.yml;

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile ../../config/wezterm/colorutils.lua}
      ${builtins.readFile ../../config/wezterm/wezterm.lua}
    '';
  };

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
      "ctrl+shift+t" = "launch --cwd=current --type=tab";
      "cmd+t" = "launch --cwd=current --type=tab";
      "cmd+enter" = "launch --cwd=current --location split";

      "alt+left" = "send_text all \\x1b\\x62";
      "alt+right" = "send_text all \\x1b\\x66";

      "cmd+up" = "neighboring_window up";
      "cmd+left" = "neighboring_window left";
      "cmd+right" = "neighboring_window right";
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

  home.packages = shared-packages ++ [ ];
}
