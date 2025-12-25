{
  description = "Nathan's minimal NixOS + Home Manager flake";

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
    system = "x86_64-linux";

    mkHost = import ./lib/mkHost.nix { inherit nixpkgs home-manager stylix; };
    mkUser = import ./lib/mkUser.nix { inherit nixpkgs home-manager stylix; };

    username = "mac";
    homeManagerStateVersion = "26.05";
  in
  {
    nixosConfigurations = {
      "lenovo-legion" = mkHost {
        inherit system username homeManagerStateVersion;
        hostname = "lenovo-legion";
        gui = "sway";
      };

      vm = mkHost {
        inherit system username homeManagerStateVersion;
        hostname = "vm";
        gui = "sway";
      };
    };

    homeConfigurations = {
      "${username}" = mkUser {
        inherit system username homeManagerStateVersion;
        gui = "sway";
      };
    };
  };
}
