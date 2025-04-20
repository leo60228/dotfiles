{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    vris.prometheus = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.vris.prometheus {
    networking.firewall.allowedTCPPorts = [ 9090 ];
    services.prometheus.exporters = {
      node = {
        enable = true;
        openFirewall = true;
        enabledCollectors = [ "systemd" ];
      };
    };
  };
}
