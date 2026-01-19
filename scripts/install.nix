{ pkgs }:

pkgs.writeShellApplication {
  name = "install";

  runtimeInputs = with pkgs; [
    bash
    coreutils
    git
    openssh
    rsync
    gnugrep
    gnused
    gawk
    perl
    util-linux
    nixos-anywhere
  ];

  text = builtins.readFile ./install-standard.sh;
}

