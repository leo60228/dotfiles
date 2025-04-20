{ config, pkgs, ... }:

with import ../components;
{
  components = home { small = true; } tailscale;

  system.stateVersion = "18.03";
}
