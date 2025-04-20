let
  lib = import ../lib;
in
lib.makeComponent "en_us" (
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
