let lib = import ../lib; in
lib.makeComponent "prometheus"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    networking.firewall.allowedTCPPorts = [ 9090 ];
    services.prometheus.exporters = {
      node = {
	enable = true;
	openFirewall = true;
      };
    };
  };
})
