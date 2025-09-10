# flake.nix
{
  description = "Mac's nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, stylix, ... }:
  let 
    mkHost = import ./lib/mkHost.nix { inherit nixpkgs home-manager self stylix; };
  in {

    overlays.default = final: prev: {
      exegol = prev.callPackage ./pkgs/exegol { };
    };

    nixosConfigurations = {

      # VM virtualBox
      vm = mkHost {
        system = "x86_64-linux";
        hostName = "vm";
        userName = "mac";
        extraModules = [ 

        ];
      };

      # Physical machine
      lenovo-legion = mkHost {
        system = "x86_64-linux";
        hostName = "lenovo-legion";
        userName = "mac";
        desktopType = "gnome";
      };
    };
  };
}

