{ inputs, pkgs, ... }:
let
  oxocarbonTheme = import ../oxocarbon.nix;
  oxocarbon = oxocarbonTheme.dark;
in
{
  fonts.fontconfig.enable = true;

  home.packages = [
    inputs.ghostty.packages.${pkgs.system}.default
    (pkgs.nerdfonts.override {
      fonts = [ "IntelOneMono" ];
    })
  ];

  home.file.".config/ghostty/config".text = ''
    background-opacity = 0.9
    font-family = IntoneMono Nerd Font
    font-size = 14
    macos-option-as-alt = true

    background = ${oxocarbon.base00}
    foreground = ${oxocarbon.base05}
    selection-invert-fg-bg = true
    cursor-color = ${oxocarbon.base05}

    window-padding-x = 16
    window-padding-y = 16
    window-theme = dark

    # black
    palette = 0=${oxocarbon.base00}
    palette = 8=${oxocarbon.base03}

    # red
    palette = 1=${oxocarbon.base08}
    palette = 9=${oxocarbon.base09}

    # green
    palette = 2=${oxocarbon.base0B}
    palette = 10=${oxocarbon.base01}

    # yellow
    palette = 3=${oxocarbon.base0A}
    palette = 11=${oxocarbon.base02}

    # blue
    palette = 4=${oxocarbon.base0D}
    palette = 12=${oxocarbon.base04}

    # purple
    palette = 5=${oxocarbon.base0E}
    palette = 13=${oxocarbon.base06}

    # aqua
    palette = 6=${oxocarbon.base0C}
    palette = 14=${oxocarbon.base0F}

    # white
    palette = 7=${oxocarbon.base05}
    palette = 15=${oxocarbon.base07}
  '';
}
