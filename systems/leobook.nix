{ config, pkgs, ... }:

with import ../components; {
  imports = [ ../cachix.nix ];

  components = efi en_us est gui kde { bluetooth = true; } steam extra home;

  networking.hostName = "leobook"; # Define your hostname.

  users.extraUsers.leo60228.extraGroups = [ "wheel" ];
}
