let
  lib = import ../lib;
in
lib.makeComponent "flatpak" (
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
      services.flatpak.enable = true;
    };
  }
)
