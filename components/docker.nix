let lib = import ../lib; in
lib.makeComponent "docker"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = true;
    virtualisation.docker.package = pkgs.docker-edge;
  };
})
