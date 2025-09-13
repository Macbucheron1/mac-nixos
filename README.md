# Mac-Nixos

My nixos configuration for daily drive

## Images

[screen1](./img/screen1.png)
[screen2](./img/screen2.png)
[screen3](./img/screen3.png)

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

- Personnaliser starship
