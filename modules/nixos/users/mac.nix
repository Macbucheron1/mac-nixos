{ pkgs, ... }:
{
  users.users.mac = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
  };
}
