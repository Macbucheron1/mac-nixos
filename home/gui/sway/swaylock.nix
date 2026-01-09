{ config, lib, pkgs, ... }:
{
  programs.swaylock = {
    enable = true;
  };

  stylix.targets.swaylock = {
    enable = true;
    image.enable = false;
  };
}

