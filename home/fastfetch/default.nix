{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
          "os"
          "kernel"
          "packages"
          "cpu"
          "gpu"
          "memory"
          "disk"
      ];
    };
  };
}