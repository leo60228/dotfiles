{
  config,
  pkgs,
  lib,
  ...
}:

with import ../components;
{
  components = efi en_us est gui kde {
    bluetooth = true;
  } docker steam extra home { deviceScaleFactor = 2; } tailscale firefox flatpak fwupd kdeconnect kvm;

  users.extraUsers.leo60228.extraGroups = [
    "wheel"
    "docker"
  ];

  networking.firewall.allowedTCPPorts = lib.range 3000 3010;
  networking.firewall.allowedUDPPorts = lib.range 3000 3010;
}
