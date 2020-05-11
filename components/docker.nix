let lib = import ../lib; in
lib.makeComponent "docker"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = false;
    virtualisation.docker.package = pkgs.docker-edge;

    users.extraUsers.leo60228.extraGroups = [ "docker" ];
  };
})
