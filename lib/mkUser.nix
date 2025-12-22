{ nixpkgs, home-manager }:{ username, system, stateVersion, gui}:
let
  pkgs = nixpkgs.legacyPackages.${system};
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit username stateVersion gui;
  };

  modules = [
    ../home/default.nix
    ../home/gui/${gui}
  ];
}
