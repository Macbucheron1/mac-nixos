{ username, ... }:
{
  virtualisation.incus = {
    enable = true;
    bucketSupport = false;
  };

  users.users.${username}.extraGroups = [ "incus-admin" ];
}
