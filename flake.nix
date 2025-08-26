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
  };
  outputs = inputs@{ self, nixpkgs, disko, home-manager, ... }:
  let 
    mkHost = import ./lib/mkHost.nix { inherit nixpkgs home-manager disko; };
  in {
    nixosConfigurations = {

      # VM virtualBox
      vm = mkHost {
        system = "x86_64-linux";
        hostName = "vm";
        disks = [ "/dev/sda" ];
        extraModules = [ ];
      };
    };
  };
}

