let lib = import ../lib; in
lib.makeComponent "shellinabox"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    services.shellinabox.enable = true;
    services.shellinabox.extraOptions = [ "--port=80" ];

    systemd.timers.shellinabox = {
      requires = [ "shellinaboxd.service" ];
      timerConfig.Unit = "shellinaboxd.service";
      timerConfig.OnUnitInactiveSec = "15m";
      timerConfig.AccuracySec = "1s";
      wantedBy = [ "multi-user.target" ];
    };
  };
})
