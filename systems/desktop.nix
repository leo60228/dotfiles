# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = efi en_us est extra gui { autoLogin = true; } kde steam docker home vfio glances flatpak mqtt;

  networking.firewall.allowedTCPPorts = [ 3000 34567 34568 ];
  networking.firewall.allowedUDPPorts = [ 4010 34567 34568 ];
}
