{ nixpkgs, home-manager, stylix }:
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
        inherit username gui homeManagerStateVersion;
      };

      home-manager.users.${username} = {
        imports = [
          ../home
          ../home/gui/${gui}
        ];

        home.stateVersion = homeManagerStateVersion;
      };
    })
  ];
}
