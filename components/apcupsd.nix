let lib = import ../lib; in
lib.makeComponent "apcupsd"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    batteryLevel = mkOption {
      default = 5;
      type = types.int;
    };
    minutes = mkOption {
      default = 3;
      type = types.int;
    };
    timeout = mkOption {
      default = 0;
      type = types.int;
    };
    prometheus = mkOption {
      default = null;
      type = types.nullOr types.str;
    };
  };

  config = {
    services.apcupsd = {
      enable = true;
      configText = ''
      UPSCABLE ether
      UPSTYPE net
      DEVICE 10.4.13.1:3551
      UPSCLASS standalone
      UPSMODE disable
      POLLTIME 10
      NETSERVER on
      NISIP 127.0.0.1
      BATTERYLEVEL ${toString cfg.batteryLevel}
      MINUTES ${toString cfg.minutes}
      TIMEOUT ${toString cfg.timeout}
      '';
    };

    systemd.services.apcupsd-killpower.enable = false;

    services.prometheus.exporters.apcupsd = mkIf (cfg.prometheus != null) {
      enable = true;
      listenAddress = cfg.prometheus;
      openFirewall = true;
    };
  };
})
