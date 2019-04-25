{ config, pkgs, ... }:

with import ../components; {
  components = efi en_us est gui kde { bluetooth = true; } docker steam extra;

  environment.systemPackages = [ pkgs.nixops ];

  networking.hostName = "leotop"; # Define your hostname.

  users.extraUsers.leo60228.extraGroups = [ "wheel" "docker" "bumblebee" "vboxusers" ];

  services.flatpak.enable = true;

  security.sudo.wheelNeedsPassword = false;

  #users.groups.bumblebee = {};

  #hardware.bumblebee.enable = true;
  #hardware.bumblebee.group = "bumblebee";
}
