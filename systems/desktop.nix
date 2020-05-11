# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = efi en_us est extra gui kde steam docker home vfio;

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
  networking.firewall.allowedTCPPorts = [ 1883 ];
  networking.firewall.allowedUDPPorts = [ 4010 ];
  services.xserver.displayManager.sddm.autoLogin = {
    enable = true;
    user = "leo60228";
  };
}
