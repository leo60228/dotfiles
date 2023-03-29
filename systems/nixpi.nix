# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = en_us est home { small = true; } router hass unifi apcupsd-server mqtt tailscale;

  services.openssh.settings.PasswordAuthentication = false;
}
