{ ... }:
{
  imports = [
    ../../mixins/docker
  ];

  networking.firewall.allowedUDPPorts = [ 8800 ];
  networking.firewall.allowedTCPPorts = [ 8900 ];

  virtualisation.oci-containers.containers = {
    lmpserver = {
      autoStart = true;
      image = "ghcr.io/lunamultiplayer/lunamultiplayer/server:master@sha256:6b12b8112af2045ff34190249b4371c5d0c956d433e9c186721e025a38e27223";
      ports = [ "8800:8800/udp" "8900:8900" ];
      volumes = [
        "/storage/lmpserver/config:/LMPServer/Config"
        "/storage/lmpserver/plugins:/LMPServer/Plugins"
        "/storage/lmpserver/universe:/LMPServer/Universe"
        "/storage/lmpserver/logs:/LMPServer/Logs"
      ];
    };
  };
}
