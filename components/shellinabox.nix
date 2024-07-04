let
  lib = import ../lib;
in
lib.makeComponent "shellinabox" (
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
      services.shellinabox.enable = true;
      services.shellinabox.extraOptions = [
        "--port=8022"
        "--css=${../files/solarized.css}"
        "--static-file=hack.ttf:${../files/hack.ttf}"
        "--static-file=hack-bold.ttf:${../files/hack-bold.ttf}"
        "--static-file=ShellInABox.js:${../files/ShellInABox.js}"
      ];

      systemd.timers.shellinabox = {
        requires = [ "shellinaboxd.service" ];
        timerConfig.Unit = "shellinaboxd.service";
        timerConfig.OnUnitInactiveSec = "15m";
        timerConfig.AccuracySec = "1s";
        wantedBy = [ "multi-user.target" ];
      };
    };
  }
)
