# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = efi en_us est extra { graalvm = true; } gui { autoLogin = true; } kde steam docker home { deviceScaleFactor = 2; } kvm glances flatpak mqtt wg prometheus ibus apcupsd { timeout = 300; minutes = 15; batteryLevel = 50; prometheus = "10.100.0.2"; } tailscale postgres mosh usbmuxd nixbuild;

  networking.firewall.allowedTCPPorts = (lib.range 3000 3010) ++ [ 34567 34568 22000 8010 6600 ];
  networking.firewall.allowedUDPPorts = [ 4010 34567 34568 21027 6600 ];

  networking.hosts."52.218.200.91" = [ "www.blaseball2.com" ];
}
