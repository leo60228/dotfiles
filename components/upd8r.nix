let lib = import ../lib; in
lib.makeComponent "upd8r"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    environment.systemPackages = [ (pkgs.callPackage ../upd8r.nix {}) ];
    systemd.services.upd8r = {
      wantedBy = [ "multi-user.target" ];
      path = [ (pkgs.callPackage ../upd8r.nix {}) ];
      script = "upd8r";
      startLimitIntervalSec = 0;
      serviceConfig.WorkingDirectory = "/var/lib/upd8r";
      serviceConfig.Restart = "on-failure";
      serviceConfig.RestartSec = 60;
    };
  };
})
