{ nixpkgs, home-manager }:{ username, system, homeManagerStateVersion, gui}:
let
  pkgs = nixpkgs.legacyPackages.${system};
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit username homeManagerStateVersion gui;
  };

  modules = [
    ../home/default.nix
    ../home/gui/${gui}
  ];
}
