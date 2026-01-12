{
  nixpkgs,
  home-manager,
  stylix,
  firefox-addons,
  nvf,
  overlays
}: {
  username,
  hostname,
  system,
  gui,
  homeManagerStateVersion,
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

      ({...}: {
        nixpkgs.overlays = overlays;
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
          ];

          home.stateVersion = homeManagerStateVersion;
        };
      })
    ];
  }
