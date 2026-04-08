{
  nixpkgs,
  home-manager,
  stylix,
  nur,
  firefox-addons,
  nixcord,
  nvf,
  vibepods,
  overlays,
  exegol-ressources,
  nix-index-database,
  codex-nvim,
  burpsuite-nix,
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
    inherit username homeManagerStateVersion gui firefox-addons vibepods exegol-ressources codex-nvim;
  };

  modules = [
    stylix.homeModules.stylix
    ../lib/theme.nix
    ../home/default.nix
    ../home/gui/${gui}
    nvf.homeManagerModules.default
    nixcord.homeModules.nixcord
    nix-index-database.homeModules.default 
    burpsuite-nix.homeManagerModules.default
  ];
}
