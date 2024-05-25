{ ... }:
let
  nasAddr = "192.168.1.2";
in
{
  fileSystems."/storage" =
    {
      device = "${nasAddr}:/volume1/media";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };

  fileSystems."/downloads" =
    {
      device = "${nasAddr}:/volume1/downloads";
      fsType = "nfs";
      options = [ "x-systemd.automount" "noauto" ];
    };
}
