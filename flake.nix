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

    nixcord = {
      url = "github:FlameFlag/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
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
    nixcord,
    disko,
    lanzaboote,
    ...
  }: let
    system = "x86_64-linux";

    overlays = import ./overlays { inherit nsearch; };
    pkgs = nixpkgs.legacyPackages.${system};

    mkHost = import ./lib/mkHost.nix {inherit nixpkgs overlays home-manager nur stylix firefox-addons nvf nixcord disko lanzaboote;};
    mkUser = import ./lib/mkUser.nix {inherit nixpkgs overlays home-manager nur stylix firefox-addons nixcord nvf;};
    mkNvim = import ./lib/mkNvim.nix { inherit pkgs nvf; };

    username = "mac";
    homeManagerStateVersion = "26.05";

    installDrv = import ./scripts/install.nix { inherit pkgs; };
  in {
    nixosConfigurations = {
      "lenovo-legion" = mkHost {
        inherit system username homeManagerStateVersion;
        hostname = "lenovo-legion";
        gui = "sway";
        useDisko = true;
        useLanzaboote = true;
      };

      standard-installer = mkHost {
        inherit system username homeManagerStateVersion;
        hostname = "standard";
        gui = "sway";
        useDisko = true;
        useLanzaboote = false;
      };
    };

    homeConfigurations = {
      "${username}" = mkUser {
        inherit system username homeManagerStateVersion;
        gui = "sway";
      };
    };

    apps.${system} = {
      install = {
        type = "app";
        program = "${installDrv}/bin/install";
      };
    };

    packages.${system}.nvim = mkNvim; 
  };
}
