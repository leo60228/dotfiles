{ config, pkgs, ... }:

with import ../components; {
  imports = [ ../cachix.nix ];

  components = efi en_us est gui kde { bluetooth = true; } docker steam extra home tailscale firefox;

  users.extraUsers.leo60228.extraGroups = [ "wheel" "docker" "bumblebee" "vboxusers" ];
}
