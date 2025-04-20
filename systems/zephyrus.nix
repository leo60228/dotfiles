{ config, pkgs, ... }:

with import ../components;
{
  components = efi en_us gui kde {
    bluetooth = true;
  } docker steam extra home tailscale flatpak fwupd kdeconnect;

  system.stateVersion = "18.03";

  users.extraUsers.leo60228.extraGroups = [
    "wheel"
    "docker"
    "bumblebee"
    "vboxusers"
  ];
}
