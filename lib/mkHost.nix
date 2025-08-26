# lib/mkHost.nix
{ nixpkgs, home-manager, disko }:

let
  lib = nixpkgs.lib;
in
{ system, hostName, userName ? "mac", disks ? [ ], extraModules ? [ ] }:
  lib.nixosSystem {
    inherit system;
    specialArgs = { inherit nixpkgs home-manager disko disks userName; };
    modules = [
      ./../hosts/${hostName}/configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${userName} = import ./../home/users/${userName};
      }
    ] ++ extraModules;
  }
