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
    , username ? "hayden"
    , work ? false
    , desktop ? false
    }:
    if type == "nixos" then
      assert address != null && pubkey != null;
      assert (hasSuffix "linux" hostPlatform);
      {
        inherit type hostPlatform address pubkey remoteBuild large username work;
      }
    else if type == "darwin" then
      assert pubkey != null;
      assert (hasSuffix "darwin" hostPlatform);
      {
        inherit type hostPlatform pubkey large username work;
      }
    else if type == "home-manager" then
      assert homeDirectory != null;
      {
        inherit type hostPlatform homeDirectory large work username address pubkey desktop;
      }
    else throw "unknown host type '${type}'";
in
{
  phoebe = mkHost {
    type = "nixos";
    address = "192.168.1.3";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPKeD80MhQQE4ZjSMsLq0hgDRWq/AuGYoqFJiBl8cGZZ";
    remoteBuild = false;
  };

  titan = mkHost {
    type = "home-manager";
    address = "192.168.4.31";
    hostPlatform = "x86_64-linux";
    pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFS3HBLH48BD7LXlGxoJFuHvzKJz8+gDY7glQPbMDmH8";
    remoteBuild = false;
    homeDirectory = "/home/hayden";
  };

  work = mkHost {
    type = "darwin";
    address = "127.0.0.1";
    hostPlatform = "aarch64-darwin";
    pubkey = "";
    username = "haydenyoung";
    work = true;
  };
}
