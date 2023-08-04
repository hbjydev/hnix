{ work, desktop, inputs }:

{ pkgs, ... }:

let
  shared-config = import ../shared/home-manager.nix { inherit inputs work; };
  shared-packages = import ../shared/home-manager-packages.nix { inherit pkgs; };
in
{
  imports = if desktop then [ shared-config ] else [ shared-config ];

  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell Integration
    ];
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile ../../config/wezterm/colorutils.lua}
      ${builtins.readFile ../../config/wezterm/wezterm.lua}
    '';
  };

  home.packages = shared-packages ++ pkgs.lib.optionals desktop [
    pkgs.discord
    pkgs.spotify
  ];
}
