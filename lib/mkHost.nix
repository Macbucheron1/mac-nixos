# lib/mkHost.nix
{ nixpkgs, home-manager, disko, stylix, self }:

let
  lib = nixpkgs.lib;
in
{ system, hostName, userName ? "mac", disks ? [ ], desktopType ? "none", extraModules ? [ ] }:
  lib.nixosSystem {
    inherit system;
    specialArgs = { inherit nixpkgs home-manager disko disks userName desktopType stylix; }; # Argument disponible pour modules/nixos
    modules = [
      ./../hosts/${hostName}/configuration.nix
      ./../modules/nixos/desktop
      ./../modules/nixos/common.nix
      stylix.nixosModules.stylix
      home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = [ self.overlays.default ]; 
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit userName desktopType stylix; }; # Argument disponible pour home
        home-manager.users.${userName} = import ./../home;
      }
    ] ++ extraModules;
  }
