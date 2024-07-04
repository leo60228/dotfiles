let
  lib = import ../lib;
in
lib.makeComponent "unifi" (
  {
    cfg,
    pkgs,
    lib,
    ...
  }:
  with lib;
  {
    opts = { };

    config = {
      services.unifi = {
        enable = true;
        unifiPackage = pkgs.unifi;
        openFirewall = true;
      };
    };
  }
)
