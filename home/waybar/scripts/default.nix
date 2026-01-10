{ pkgs, lib, vpnIfaces }:

let
  path = lib.makeBinPath [ pkgs.iproute2 pkgs.jq pkgs.coreutils ];
  vpnIfacesStr = builtins.concatStringsSep " " vpnIfaces;
  excludedJson = builtins.toJSON ([ "lo" ] ++ vpnIfaces);

  mk = name: src:
    pkgs.writeShellScriptBin name (
      builtins.replaceStrings
        [ "@PATH@" "@VPN_IFACES@" "@EXCLUDED_JSON@" ]
        [ path vpnIfacesStr excludedJson ]
        (builtins.readFile src)
    );
in
{
  vpnUp = mk "waybar-vpn-up" ./vpn-up.sh;
  vpnIp = mk "waybar-vpn-ip" ./vpn-ip.sh;
  lanIp = mk "waybar-lan-ip" ./lan-ip.sh;
}

