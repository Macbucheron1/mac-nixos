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

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nsearch = {
      url = "github:niksingh710/nsearch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    stylix,
    firefox-addons,
    nvf,
    nur,
    nsearch,
    ...
  }: let
    system = "x86_64-linux";

    overlays = import ./overlays { inherit nsearch; };

    mkHost = import ./lib/mkHost.nix {inherit nixpkgs overlays home-manager nur stylix firefox-addons nvf;};
    mkUser = import ./lib/mkUser.nix {inherit nixpkgs overlays home-manager nur stylix firefox-addons nvf;};

    username = "mac";
    homeManagerStateVersion = "26.05";
  in {
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
