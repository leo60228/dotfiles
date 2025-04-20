let
  lib = import ../lib;
in
lib.makeComponent "kde" (
  {
    cfg,
    pkgs,
    lib,
    flakes,
    ...
  }:
  with lib;
  {
    opts = {
      bluetooth = mkOption {
        default = true;
        type = types.bool;
      };
    };

    config = {
      hardware.bluetooth.enable = cfg.bluetooth;
    };
  }
)
