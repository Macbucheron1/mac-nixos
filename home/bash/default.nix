{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    #initExtra = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';
  };
}