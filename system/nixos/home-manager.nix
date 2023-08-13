{ work, desktop, inputs }:

{ pkgs, ... }:

let
  shared-config = import ../shared/home-manager.nix { inherit inputs work; };
  shared-packages = import ../shared/home-manager-packages.nix { inherit pkgs; };
in
{
  imports = if desktop then [ shared-config ] else [ shared-config ];

  dconf.settings = if desktop then {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [];
      switch-applications-backwards = [];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backwards = [ "<Shift><Alt>Tab" ];
    };
  } else {};

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
    pkgs.slack

    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.appindicator
  ];
}
