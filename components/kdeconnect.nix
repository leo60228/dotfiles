let
  lib = import ../lib;
in
lib.makeComponent "kdeconnect" (
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
      programs.kdeconnect.enable = true;
    };
  }
)
