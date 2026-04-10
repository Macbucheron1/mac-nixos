{ username, ... }:
{
  virtualisation.incus = {
    enable = true;
  };

  users.users.${username}.extraGroups = [ "incus-admin" ];
}
