{ nixpkgs, home-manager }:
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

    home-manager.nixosModules.home-manager

    ({ ... }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.extraSpecialArgs = {
        inherit username gui homeManagerStateVersion;
      };

      home-manager.users.${username} = {
        imports = [
          ../home/default.nix
          ../home/gui/${gui}
        ];

        home.stateVersion = homeManagerStateVersion;
      };
    })
  ];
}
