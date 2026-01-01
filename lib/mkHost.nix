{ nixpkgs, home-manager, stylix, firefox-addons, nixvim }:
{ username, hostname, system, gui, homeManagerStateVersion }:

let
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

    ({ ... }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.extraSpecialArgs = {
        inherit username gui homeManagerStateVersion firefox-addons;
      };

      home-manager.users.${username} = {
        imports = [
          ../home
          ../home/gui/${gui}

          nixvim.homeModules.nixvim
        ];

        home.stateVersion = homeManagerStateVersion;
      };
    })
  ];
}
