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
	extraComponents = [ "default_config" "met" "hue" "ipp" "cast" "serial" "mqtt" "unifi" "nut" "backup" ];
      };
    };

    services.zigbee2mqtt = {
      enable = true;
      settings = {
	homeassistant = true;
	serial.port = "/dev/serial/by-id/usb-Texas_Instruments_TI_CC2531_USB_CDC___0X00124B001949B2CD-if00";
	frontend.port = 8456;
	advanced.network_key = "!secret network_key";
	mqtt.server = "mqtt://10.4.13.1";
      };
    };

    power.ups = {
      enable = true;
      mode = "netserver";
      ups.apcupsd = {
	driver = "apcupsd-ups";
	port = "10.4.13.1";
      };
    };
  };
})
