{
  nixpkgs,
  home-manager,
  stylix,
  nur,
  firefox-addons,
  nvf,
  nixcord,
  disko,
  lanzaboote,
  vibepods,
  overlays,
  exegol-ressources,
  nix-index-database,
  codex-nvim,
  burpsuite-nix,
}: {
  username,
  hostname,
  system,
  gui,
  homeManagerStateVersion,
  useDisko ? false,
  useLanzaboote ? false,
}: let
  lib = nixpkgs.lib;
in
  lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit username hostname gui;
    };

    modules = [
      ../nixos
      ../hosts/${hostname}
      ../nixos/gui/${gui}

      stylix.nixosModules.stylix
      nix-index-database.nixosModules.default
      ../lib/theme.nix

      home-manager.nixosModules.home-manager
      nur.modules.nixos.default

      ({...}: {
        nixpkgs.overlays = overlays ++ [ nur.overlays.default ];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.extraSpecialArgs = {
          inherit username gui homeManagerStateVersion firefox-addons vibepods exegol-ressources codex-nvim;
        };

        home-manager.users.${username} = {
          imports = [
            ../home
            ../home/gui/${gui}

            nvf.homeManagerModules.default
            nixcord.homeModules.nixcord
            nix-index-database.homeModules.default
            burpsuite-nix.homeManagerModules.default
          ];

          home.stateVersion = homeManagerStateVersion;
        };
      })
    ]
    ++ (lib.optionals useDisko [
      disko.nixosModules.disko
      ../hosts/${hostname}/disko.nix
    ]) ++ (lib.optionals useLanzaboote [
      lanzaboote.nixosModules.lanzaboote
      ../nixos/lanzaboot/default.nix
    ]);
  }
