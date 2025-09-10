{ pkgs, ... } :
{
  services = { 
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gnome.gcr-ssh-agent.enable = false;
    gnome.core-apps.enable = false;
  };

  # Fallback icons
  environment.systemPackages = with pkgs; [
    adwaita-icon-theme   
    vanilla-dmz        
  ];

}
