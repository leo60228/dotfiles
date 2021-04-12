let lib = import ../lib; in
lib.makeComponent "mosh"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    programs.mosh.enable = true;
  };
})
