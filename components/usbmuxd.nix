let
  lib = import ../lib;
in
lib.makeComponent "usbmuxd" (
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
      services.usbmuxd.enable = true;
    };
  }
)
