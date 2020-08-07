let lib = import ../lib; in
lib.makeComponent "glances"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    systemd.services.glances = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.glances ];
      script = "glances --webserver --bind 0.0.0.0 --port 61208";
    };

    networking.firewall.allowedTCPPorts = [ 61208 ];
  };
})
