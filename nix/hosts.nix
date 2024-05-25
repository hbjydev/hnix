let
  hasSuffix = suffix: content:
    let
      inherit (builtins) stringLength substring;
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
    lenContent >= lenSuffix
    && substring (lenContent - lenSuffix) lenContent content == suffix
  ;

  mkHost =
    { type
    , hostPlatform
    , address ? null
    , pubkey ? null
    , homeDirectory ? null
    , remoteBuild ? true
    , large ? false
    }:
    if type == "nixos" then
      assert address != null && pubkey != null;
      assert (hasSuffix "linux" hostPlatform);
      {
        inherit type hostPlatform address pubkey remoteBuild large;
      }
    else if type == "darwin" then
      assert pubkey != null;
      assert (hasSuffix "darwin" hostPlatform);
      {
        inherit type hostPlatform pubkey large;
      }
    else if type == "home-manager" then
      assert homeDirectory != null;
      {
        inherit type hostPlatform homeDirectory large;
      }
    else throw "unknown host type '${type}'";
in
{
  phoebe = mkHost {
    type = "nixos";
    address = "192.168.1.3";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKeD80MhQQE4ZjSMsLq0hgDRWq/AuGYoqFJiBl8cGZZ";
  };

  titan = mkHost {
    type = "nixos";
    address = "192.168.4.31";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINEYBow7fJbllBhI09yM/W1k5TyfqsR/rg9ddVAWubri";
    remoteBuild = false;
  };

  work = mkHost {
    type = "darwin";
    address = "127.0.0.1";
    hostPlatform = "aarch64-darwin";
    pubkey = "";
  };
}
