# lib/mkHost.nix
{ nixpkgs, home-manager, disko, self }:

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
        nixpkgs.overlays = [ self.overlays.default ]; 
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit userName; }; # Pass userName to home-manager
        home-manager.users.${userName} = import ./../home;
      }
    ] ++ extraModules;
  }
