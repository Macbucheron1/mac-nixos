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

    vibepods = {
      url = "github:Macbucheron1/vibepods-cli";
    };

    codex-nvim = {
      url = "github:johnseth97/codex.nvim";
      flake = false;
    };

    nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    exegol-ressources = {
      url = "github:Macbucheron1/exegol-ressources";
      flake = false;
    };

    burpsuite-nix = {
        url = "github:Red-Flake/burpsuite-nix";
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
    vibepods,
    exegol-ressources,
    nix-index-database,
    codex-nvim,
    burpsuite-nix,
    ...
  }: let
    system = "x86_64-linux";

    overlays = import ./overlays { inherit nsearch; };
    pkgs = nixpkgs.legacyPackages.${system};

    mkHost = import ./lib/mkHost.nix {inherit nixpkgs overlays home-manager nur stylix firefox-addons nvf nixcord disko lanzaboote vibepods exegol-ressources nix-index-database codex-nvim burpsuite-nix;};
    mkUser = import ./lib/mkUser.nix {inherit nixpkgs overlays home-manager nur stylix firefox-addons nixcord nvf vibepods exegol-ressources nix-index-database codex-nvim burpsuite-nix;};
    mkNvim = import ./lib/mkNvim.nix { inherit pkgs nvf codex-nvim; };

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
