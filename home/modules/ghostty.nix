{ inputs, pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;

  oxocarbonTheme = import ../oxocarbon.nix;
  oxocarbon = oxocarbonTheme.dark;
in
{
  fonts.fontconfig.enable = true;

  home.packages = [
    (pkgs.nerdfonts.override {
      fonts = [ "IntelOneMono" ];
    })
  ];

  programs.ghostty = {
    enable = true;
    package = mkIf stdenv.isLinux inputs.ghostty.packages.${pkgs.system}.ghostty;

    settings = {
      font-family = "IntoneMono Nerd Font";
      font-size = 14;
      macos-option-as-alt = false;

      window-padding-x = 16;
      window-padding-y = 16;
      window-theme = "dark";
      window-decoration = true;

      background = oxocarbon.base00;
      background-opacity = 0.9;
      foreground = oxocarbon.base05;
      selection-invert-fg-bg = true;
      cursor-color = oxocarbon.base05;

      palette = [
        # black
        "0=${oxocarbon.base00}"
        "8=${oxocarbon.base03}"

        # red
        "1=${oxocarbon.base08}"
        "9=${oxocarbon.base09}"

        # green
        "2=${oxocarbon.base0B}"
        "10=${oxocarbon.base01}"

        # yellow
        "3=${oxocarbon.base0A}"
        "11=${oxocarbon.base02}"

        # blue
        "4=${oxocarbon.base0D}"
        "12=${oxocarbon.base04}"

        # purple
        "5=${oxocarbon.base0E}"
        "13=${oxocarbon.base06}"

        # aqua
        "6=${oxocarbon.base0C}"
        "14=${oxocarbon.base0F}"

        # white
        "7=${oxocarbon.base05}"
        "15=${oxocarbon.base07}"
      ];
    };

    keybindings = {
      "ctrl+shift+right_bracket" = "next_tab";
      "ctrl+shift+left_bracket" = "previous_tab";

      "alt+left" = "esc:b";
      "alt+right" = "esc:f";

      "ctrl+shift+enter" = "new_split:auto";
      "ctrl+shift+up" = "goto_split:top";
      "ctrl+shift+down" = "goto_split:bottom";
      "ctrl+shift+left" = "goto_split:left";
      "ctrl+shift+right" = "goto_split:right";
    };
  };
}
