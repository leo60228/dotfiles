{ config, pkgs, ... }:

with import ../components;
{
  components = efi en_us home { small = true; } tailscale;
}
