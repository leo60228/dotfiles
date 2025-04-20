{ config, pkgs, ... }:

with import ../components;
{
  components = efi home { small = true; } tailscale;

  system.stateVersion = "18.03";
}
