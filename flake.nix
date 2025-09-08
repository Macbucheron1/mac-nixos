{
  description = "Mac's nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = inputs@{ self, nixpkgs, disko, home-manager, catppuccin, ... }:
  let 
    mkHost = import ./lib/mkHost.nix { inherit nixpkgs home-manager disko catppuccin self; };
  in {

    overlays.default = final: prev: {
      exegol = prev.callPackage ./pkgs/exegol { };
    };

    nixosConfigurations = {

      # VM virtualBox
      vm = mkHost {
        system = "x86_64-linux";
        hostName = "vm";
        disks = [ "/dev/sda" ];
        userName = "mac";
        extraModules = [ 
          disko.nixosModules.disko
          ./hosts/vm/disko.nix
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

