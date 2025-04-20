{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    vris.apcupsd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      batteryLevel = lib.mkOption {
        type = lib.types.int;
        default = 5;
      };
      minutes = lib.mkOption {
        type = lib.types.int;
        default = 3;
      };
      timeout = lib.mkOption {
        type = lib.types.int;
        default = 0;
      };
    };
  };

  config = lib.mkIf config.vris.apcupsd.enable {
    services.apcupsd = {
      enable = true;
      configText = ''
        UPSCABLE ether
        UPSTYPE net
        DEVICE leoserv:3551
        UPSCLASS standalone
        UPSMODE disable
        POLLTIME 10
        NETSERVER on
        NISIP 127.0.0.1
        BATTERYLEVEL ${toString config.vris.apcupsd.batteryLevel}
        MINUTES ${toString config.vris.apcupsd.minutes}
        TIMEOUT ${toString config.vris.apcupsd.timeout}
      '';
    };

    systemd.services.apcupsd-killpower.enable = false;

    services.prometheus.exporters.apcupsd = lib.mkIf config.vris.prometheus {
      enable = true;
      openFirewall = true;
    };
  };
}
