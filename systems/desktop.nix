# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = efi en_us est extra gui kde steam docker home vfio glances;

  # flatpak
  services.flatpak.enable = true;

  # mqtt
  services.mosquitto = {
    enable = true;
    allowAnonymous = true;
    host = "0.0.0.0";
    users = {};
    aclExtraConf = ''
    topic readwrite #
    user DVES_USER
    topic readwrite #
    '';
  };
  networking.firewall.allowedTCPPorts = [ 1883 3000 34567 34568 ];
  networking.firewall.allowedUDPPorts = [ 4010 34567 34568 ];
  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "leo60228";
  };
}
