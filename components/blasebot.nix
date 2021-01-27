let lib = import ../lib; in
lib.makeComponent "blasebot"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    environment.systemPackages = [ (pkgs.callPackage ../blasebot.nix {}) ];
    systemd.services.blasebot = {
      wantedBy = [ "multi-user.target" ];
      path = [ (pkgs.callPackage ../blasebot.nix {}) ];
      script = "blasebot";
      serviceConfig.WorkingDirectory = "/var/lib/blasebot";
      serviceConfig.Restart = "on-failure";
    };
  };
})
