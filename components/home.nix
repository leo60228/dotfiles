let lib = import ../lib; in
lib.makeComponent "home"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    small = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = {
    home-manager = {
      useGlobalPkgs = true;
      users.leo60228 = import ../home.nix {
	inherit (cfg) small;
      };
    };
  };
})
