let lib = import ../lib; in
lib.makeComponent "hass"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    networking.firewall.allowedTCPPorts = [ 8123 ];

    services.home-assistant = {
      enable = true;
      config = null;
      package = pkgs.home-assistant.override {
	extraComponents = [ "default_config" "met" "hue" "ipp" "cast" "serial" "mqtt" "unifi" ];
      };
    };
  };
})
