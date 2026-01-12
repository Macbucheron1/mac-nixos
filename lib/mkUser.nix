{
  nixpkgs,
  home-manager,
  stylix,
  firefox-addons,
  nvf
}: {
  username,
  system,
  homeManagerStateVersion,
  gui,
}: let
  pkgs = nixpkgs.legacyPackages.${system};
in
  home-manager.lib.homeManagerConfiguration {
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
    ];
  }
