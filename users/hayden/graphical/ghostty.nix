{ ghostty-hm, ghostty, pkgs, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs) stdenv;
  oxocarbon = (import ../theme.nix).oxocarbon;
in
{
  imports = [ ghostty-hm.homeModules.default ];

  fonts.fontconfig.enable = true;

  home.packages = [
    (pkgs.nerdfonts.override {
      fonts = [ "GeistMono" ];
    })
  ];

  programs.ghostty = {
    enable = true;
    package = mkIf stdenv.isLinux ghostty.packages.${pkgs.system}.ghostty;

    settings = {
      font-family = "GeistMono Nerd Font";
      font-size = 14;
      macos-option-as-alt = false;

      window-padding-x = 16;
      window-padding-y = 16;
      window-theme = "dark";
      window-decoration = true;

      background = oxocarbon.dark.base00;
      background-opacity = 0.9;
      foreground = oxocarbon.dark.base05;
      selection-invert-fg-bg = true;
      cursor-color = oxocarbon.dark.base05;

      palette = [
        # black
        "0=${oxocarbon.dark.base00}"
        "8=${oxocarbon.dark.base03}"

        # red
        "1=${oxocarbon.dark.base08}"
        "9=${oxocarbon.dark.base09}"

        # green
        "2=${oxocarbon.dark.base0B}"
        "10=${oxocarbon.dark.base01}"

        # yellow
        "3=${oxocarbon.dark.base0A}"
        "11=${oxocarbon.dark.base02}"

        # blue
        "4=${oxocarbon.dark.base0D}"
        "12=${oxocarbon.dark.base04}"

        # purple
        "5=${oxocarbon.dark.base0E}"
        "13=${oxocarbon.dark.base06}"

        # aqua
        "6=${oxocarbon.dark.base0C}"
        "14=${oxocarbon.dark.base0F}"

        # white
        "7=${oxocarbon.dark.base05}"
        "15=${oxocarbon.dark.base07}"
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
