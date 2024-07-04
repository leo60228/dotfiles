let
  lib = import ../lib;
in
lib.makeComponent "cross" (
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
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    };
  }
)
