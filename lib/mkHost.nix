# lib/mkHost.nix
{ nixpkgs, home-manager, disko, catppuccin, self }:

let
  lib = nixpkgs.lib;
in
{ system, hostName, userName ? "mac", disks ? [ ], desktopType ? "none", extraModules ? [ ] }:
  lib.nixosSystem {
    inherit system;
    specialArgs = { inherit nixpkgs home-manager disko disks catppuccin userName desktopType; };
    modules = [
      ./../hosts/${hostName}/configuration.nix
      ./../modules/nixos/desktop
      home-manager.nixosModules.home-manager
      {
        nixpkgs.overlays = [ self.overlays.default ]; 
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit userName catppuccin desktopType; }; # Pass userName to home-manager
        home-manager.users.${userName} = import ./../home;
      }
    ] ++ extraModules;
  }
