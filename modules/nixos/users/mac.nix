{ pkgs, ... }:
{
  users.users.mac = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];   # base commune
  };
}
