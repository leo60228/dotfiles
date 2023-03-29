let lib = import ../lib; in
lib.makeComponent "server"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    services.openssh.settings.GatewayPorts = "yes";
  };
})
