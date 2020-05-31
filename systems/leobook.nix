{ config, pkgs, ... }:

with import ../components; {
  imports = [ ../cachix.nix ];

  components = efi en_us est gui kde steam extra home { small = true; };

  networking.hostName = "leobook"; # Define your hostname.

  users.extraUsers.leo60228.extraGroups = [ "wheel" ];

  services.xserver.windowManager.openbox.enable = true;
}
