let
  lib = import ../lib;
in
lib.makeComponent "hass" (
  {
    cfg,
    pkgs,
    lib,
    ...
  }:
  with lib;
  {
    opts = { };

    config = {
      networking.firewall.allowedTCPPorts = [
        8123
        21063
        8482
        5540
      ];
      networking.firewall.allowedUDPPorts = [
        5353
        5540
      ];

      virtualisation.oci-containers = {
        backend = "podman";
        containers = {
          homeassistant = {
            volumes = [ "home-assistant:/config" ];
            environment.TZ = "America/New_York";
            environment.PYTHONPATH = "/config/deps"; # https://github.com/home-assistant/core/issues/127966
            image = "ghcr.io/home-assistant/home-assistant:stable";
            extraOptions = [
              "--privileged"
              "--network=host"
              "--pull=newer"
            ];
          };
          hamh = {
            volumes = [ "home-assistant-matter-hub:/data" ];
            environment.TZ = "America/New_York";
            environmentFiles = [ "/var/lib/hamh-secrets" ];
            image = "ghcr.io/t0bst4r/home-assistant-matter-hub:latest";
            extraOptions = [
              "--network=host"
              "--pull=newer"
            ];
          };
        };
      };

      services.zigbee2mqtt = {
        enable = true;
        settings = {
          homeassistant = true;
          serial.port = "/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_a0b342a38245ed119082c68f0a86e0b4-if00-port0";
          frontend.port = 8456;
          advanced.network_key = "!secret network_key";
          mqtt.server = "mqtt://127.0.0.1";
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
        upsd.listen = [ { address = "0.0.0.0"; } ];
        upsmon.settings.MINSUPPLIES = 0;
      };
    };
  }
)
