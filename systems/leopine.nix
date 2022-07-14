{ config, pkgs, lib, ... }:
with import ../components; rec {
  components = efi { removable = true; } en_us est home { small = true; } tailscale klipper;
}
