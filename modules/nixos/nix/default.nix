{ ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
    settings.auto-optimise-store = true;
  };

  boot.loader.systemd-boot.configurationLimit = 10;
}
