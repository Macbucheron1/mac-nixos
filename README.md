# Mac-Nixos

My nixos configuration for daily drive

## Install on a VM

To try this config on a VM using nixos iso (minimal or graphical), launch a vm with enough ram and disk space.
```bash
git clone https://github.com/macbucheron1/mac-nixos
cd mac-nixos
```

Modify the script to set the correct disk then

```bash
bash install.sh
```

This will launch the installation
Then to finalise create a password for the user

```bash
nixos-enter --root /mnt 
passwd mac
```

then exit and reboot
```bash
exit
reboot
```

## To-DO

- Verifier les configs bluetooth et wifi (natif gnome mais verifier)
- Personnalisation alacritty & shell
- Réparer le demarrage sur VM
- Personnaliser fastfetch et le mettre au lancement
- continuer de mieux moduler gnome et le code de maniere générale