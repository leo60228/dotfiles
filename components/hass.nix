let lib = import ../lib; in
lib.makeComponent "hass"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    networking.firewall.allowedTCPPorts = [ 8123 ];

    virtualisation.oci-containers = {
      backend = "podman";
      containers.homeassistant = {
	volumes = [ "home-assistant:/config" ];
	environment.TZ = "America/New_York";
	image = "ghcr.io/home-assistant/home-assistant:2023.8.3";
	extraOptions = [ "--network=host" ];
      };
    };

    services.zigbee2mqtt = {
      enable = true;
      settings = {
	homeassistant = true;
	serial.port = "/dev/serial/by-id/usb-Texas_Instruments_TI_CC2531_USB_CDC___0X00124B001949B2CD-if00";
	frontend.port = 8456;
	advanced.network_key = "!secret network_key";
	mqtt.server = "mqtt://leoserv";
	groups = "groups.yaml";
      };
    };

    power.ups = {
      enable = true;
      mode = "netserver";
      ups.apcupsd = {
	driver = "apcupsd-ups";
	port = "leoserv";
      };
    };
  };
})
