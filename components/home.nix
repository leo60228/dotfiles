let lib = import ../lib; in
lib.makeComponent "home"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    home-manager.users.leo60228 = import ../home.nix;
  };
})
