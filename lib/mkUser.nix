{
  nixpkgs,
  home-manager,
  stylix,
  nur,
  firefox-addons,
  nixcord,
  nvf,
  overlays
}: {
  username,
  system,
  homeManagerStateVersion,
  gui,
}: let
  pkgs = import nixpkgs { 
    inherit system; 
    overlays = overlays ++ [ nur.overlays.default ]; 
  };
in home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit username homeManagerStateVersion gui firefox-addons;
  };

  modules = [
    stylix.homeModules.stylix
    ../lib/theme.nix
    ../home/default.nix
    ../home/gui/${gui}
    nvf.homeManagerModules.default
    nixcord.homeModules.nixcord
  ];
}
