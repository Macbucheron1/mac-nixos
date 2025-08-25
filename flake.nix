{
  description = "Mac's nixos config";

  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nixpkgs, disko, home-manager, ... }:
  # NOTE: 'nixos' is the default hostname
  let 
    system = "x86_64-linux";
    disks = [ "/dev/sda" ];
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit disks;
      };
      modules = [ 
        ./configuration.nix
        disko.nixosModules.disko
        ./disko-config.nix
	      ./gnome.nix 

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mac = import ./home/mac.nix;
        }
      ];
    };
  };
}

