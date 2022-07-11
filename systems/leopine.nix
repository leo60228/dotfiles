{ config, pkgs, lib, ... }:
with import ../components; rec {
  components = en_us est home { small = true; } tailscale;
}
