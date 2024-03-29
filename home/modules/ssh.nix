{ work, isDarwin, config, ... }:
{
  sops.secrets.ssh_config_work = {
    path = "${config.home.homeDirectory}/.ssh/config.d/work";
  };

  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPersist = "10m";
    controlPath = "/tmp/ssh.%r.%n.%p";
    forwardAgent = true;

    includes = ["config.d/*"];
    matchBlocks."*".extraOptions = {
      IdentityAgent = (
        if isDarwin
        then "\"~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
        else "~/.1password/agent.sock"
      );
      User = if work then "hyoung" else "hayden";
    };
  };
}
