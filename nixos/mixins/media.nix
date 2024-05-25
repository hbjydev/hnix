{ ... }:
{
  # Shared group (and user for Docker) to deal with permissions
  users.extraUsers.media = {
    isNormalUser = true;
    home = "/dev/null";
    uid = 1234;
    description = "Media user";
    createHome = false;
    shell = "/sbin/nologin";
  };

  users.groups.media = { };
}
