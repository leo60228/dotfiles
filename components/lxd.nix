let
  lib = import ../lib;
in
lib.makeComponent "lxd" (
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
      virtualisation.lxd.enable = true;
      users.extraUsers.leo60228.extraGroups = [ "lxd" ];
    };
  }
)
