{ work, isDarwin }:
{ ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks."*".extraOptions = {
      IdentityAgent = (
        if isDarwin
        then "\"~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
        else "~/.1password/agent.sock"
      );
      ControlMaster = "auto";
      ControlPath = "/tmp/%r@%h:%p";
      ControlPersist = "10m";
      Compression = "yes";
      User = if work then "hyoung" else "";
    };
  };
}
