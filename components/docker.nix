let lib = import ../lib; in
lib.makeComponent "docker"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
      package = pkgs.docker-edge;
      extraOptions = "--experimental";
    };

    users.extraUsers.leo60228.extraGroups = [ "docker" ];
  };
})
