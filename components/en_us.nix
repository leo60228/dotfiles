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
      environment.systemPackages = with pkgs; [
        aspell
        aspellDicts.en
        aspellDicts.en-computers
      ];
      environment.etc."/etc/aspell.conf".text = ''
        master en_US
        extra-dicts en-computers.rws
        add-extra-dicts en_US-science.rws
      '';
    };
  }
)
