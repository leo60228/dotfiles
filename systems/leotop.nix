{ config, pkgs, ... }:

with import ../components; {
  imports = [ ../cachix.nix ];

  components = efi { removable = true; } en_us est gui kde { bluetooth = true; } docker steam extra { graalvm = true; } home kvm tailscale flatpak;

  users.extraUsers.leo60228.extraGroups = [ "wheel" "docker" "bumblebee" "vboxusers" ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  networking.firewall.allowedTCPPorts = [ 3000 ];
}
