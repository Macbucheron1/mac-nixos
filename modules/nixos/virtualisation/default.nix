{ config, pkgs, lib, ... }:

{
  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;  
      runAsRoot = true; 
      swtpm.enable = true;

      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override { secureBoot = true; tpmSupport = true; }).fd
        ];
      };
    };
  };

  programs.virt-manager.enable = true;

  # Pour passer de vbox à virt-manager 
  # https://nixos.wiki/wiki/Virt-manager (voir partie "Migrating from vbox to virt-manager")
}
