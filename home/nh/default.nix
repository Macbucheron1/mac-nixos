{ ... }:
{
  programs.nh = rec {
    enable = true;
    clean = { 
    	enable = true;
	extraArgs = "--keep-since 4d --keep 3";
    };
    flake = /home/mac/Documents/mac-nixos;
    homeFlake = /home/mac/Documents/mac-nixos; 
    osFlake = /home/mac/Documents/mac-nixos;

  };
}
