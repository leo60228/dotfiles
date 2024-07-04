let
  lib = import ../lib;
in
lib.makeComponent "reposilite" (
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
      systemd.services.reposilite = {
        wantedBy = [ "multi-user.target" ];

        script = "${pkgs.leoPkgs.reposilite}/bin/reposilite -lc /etc/reposilite/reposilite.cdn -wd /var/lib/reposilite";

        serviceConfig = {
          TimeoutStopSec = 10;
          Restart = "on-failure";
          RestartSec = 5;
          DynamicUser = true;
          StateDirectory = "reposilite";
          ConfigurationDirectory = "reposilite";
          WorkingDirectory = "/var/lib/reposilite";
        };
      };
    };
  }
)
