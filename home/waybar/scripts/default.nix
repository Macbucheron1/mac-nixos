{ pkgs, lib, vpnIfaces, vibepodsPkg }:

let
  path = lib.makeBinPath [ pkgs.iproute2 pkgs.jq pkgs.coreutils pkgs.rofi vibepodsPkg ];
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
  airpods = mk "waybar-airpods" ./airpods.sh;
  airpodsMode = mk "waybar-airpods-mode" ./airpods-mode.sh;
}
