{ hostType, pkgs, ... }:
if hostType == "nixos" then {
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell Integration
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1Password
      { id = "ammjkodgmmoknidbanneddgankgfejfh"; } # 7TV
    ];
  };
}
else {}
