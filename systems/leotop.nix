{ config, pkgs, ... }:

with import ../components; {
  components = efi en_us est gui kde { bluetooth = true; } docker steam extra home;

  networking.hostName = "leotop2"; # Define your hostname.

  users.extraUsers.leo60228.extraGroups = [ "wheel" "docker" "bumblebee" "vboxusers" ];
}
