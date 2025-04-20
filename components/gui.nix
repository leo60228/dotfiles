let
  lib = import ../lib;
in
lib.makeComponent "gui" (
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
      vris.graphical = true;
    };
  }
)
