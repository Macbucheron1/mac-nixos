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

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";

    mkHost = import ./lib/mkHost.nix { inherit nixpkgs; };
    mkUser = import ./lib/mkUser.nix { inherit nixpkgs home-manager; };

    username = "mac";
  in
  {
    nixosConfigurations = {
      "lenovo-legion" = mkHost {
        inherit system username;
        hostname = "lenovo-legion";
        gui = "tty";
      };

      vm = mkHost {
        inherit system username;
        hostname = "vm";
        gui = "sway";
      };
    };

    homeConfigurations = {
      "${username}" = mkUser {
        inherit system username;
        stateVersion = "24.05";
        gui = "sway";
      };
    };
  };
}
