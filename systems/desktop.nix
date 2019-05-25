# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = efi en_us est extra gui kde steam docker home vfio;

  # flatpak
  services.flatpak.enable = true;
}
