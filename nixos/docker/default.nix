{ username, ... }:
{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      bip = "172.30.0.1/24"; 
      default-address-pools = [ {
        base = "172.29.0.0/16"; 
        size = 24; 
      } ];
    };
  };

  users.users.${username}.extraGroups = [ "docker" ];
}
