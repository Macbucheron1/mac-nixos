{ pkgs }:
rec {
  exegol = pkgs.callPackage ./exegol.nix { };
}

