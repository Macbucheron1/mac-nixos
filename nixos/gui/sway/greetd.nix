{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd '${pkgs.sway}/bin/sway -c /etc/sway-greetd-config'";        
        user = "greeter";
      };
    };
  };

  environment.etc."sway-greetd-config".text = ''
    set $mod Mod4
    bindsym $mod+Return exec ${pkgs.foot}/bin/foot
    bindsym $mod+Shift+e exec "swaymsg exit"
  '';

  programs.sway.enable = true;
}