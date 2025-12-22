{ nixpkgs }:{ username, hostname, system, gui}:

let
  lib = nixpkgs.lib;
in

lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit username hostname gui;
  };

  modules = [
    ../nixos
    ../hosts/${hostname}
    ../nixos/gui/${gui}
  ];
}
