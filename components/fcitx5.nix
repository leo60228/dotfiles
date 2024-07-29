let
  lib = import ../lib;
in
lib.makeComponent "fcitx5" (
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
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
      };
    };
  }
)
