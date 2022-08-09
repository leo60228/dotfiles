{ config, pkgs, ... }:

with import ../components; {
  components = efi en_us est home { small = true; } tailscale;
}
