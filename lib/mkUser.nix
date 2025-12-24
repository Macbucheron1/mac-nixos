{ nixpkgs, home-manager, stylix }:
{ username, system, homeManagerStateVersion, gui }:
let
  pkgs = nixpkgs.legacyPackages.${system};
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit username homeManagerStateVersion gui;
  };

  modules = [
    stylix.homeManagerModules.stylix
    ../lib/theme.nix
    ../home/default.nix
    ../home/gui/${gui}
  ];
}
