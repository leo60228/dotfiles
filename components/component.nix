let
  lib = import ../lib;
in
lib.makeComponent "component" (
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

    };
  }
)
