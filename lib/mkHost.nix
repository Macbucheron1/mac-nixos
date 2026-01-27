{
  nixpkgs,
  home-manager,
  stylix,
  nur,
  firefox-addons,
  nvf,
  nixcord,
  disko,
  overlays
}: {
  username,
  hostname,
  system,
  gui,
  homeManagerStateVersion,
  useDisko ? false,
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
      ../lib/theme.nix

      home-manager.nixosModules.home-manager
      nur.modules.nixos.default

      ({...}: {
        nixpkgs.overlays = overlays ++ [ nur.overlays.default ];
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.extraSpecialArgs = {
          inherit username gui homeManagerStateVersion firefox-addons;
        };

        home-manager.users.${username} = {
          imports = [
            ../home
            ../home/gui/${gui}

            nvf.homeManagerModules.default
            nixcord.homeModules.nixcord
          ];

          home.stateVersion = homeManagerStateVersion;
        };
      })
    ]
    ++ (lib.optionals useDisko [
      disko.nixosModules.disko
      ../hosts/${hostname}/disko.nix
    ]);
  }
