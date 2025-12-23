{ ... }:
{
    security.polkit.enable = true;

    imports = [ ./greetd.nix ];
}