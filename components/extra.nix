let
  lib = import ../lib;
in
lib.makeComponent "extra" (
  {
    config,
    cfg,
    pkgs,
    lib,
    flakes,
    ...
  }:
  with lib;
  {
    opts = { };

    config = {
      vris.workstation = true;
    };
  }
)
