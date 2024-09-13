{ config, pkgs, ... }:

with import ../components;
{
  components = efi en_us est gui kde {
    bluetooth = true;
  } docker steam extra home { deviceScaleFactor = 2; } tailscale firefox flatpak fwupd kdeconnect;

  users.extraUsers.leo60228.extraGroups = [
    "wheel"
    "docker"
  ];
}
