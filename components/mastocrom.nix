let lib = import ../lib; in
lib.makeComponent "mastocrom"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    environment.systemPackages = [ (pkgs.callPackage ../mastocrom.nix {}) ];
    systemd.services.mastocrom = {
      wantedBy = [ "multi-user.target" ];
      path = [ (pkgs.callPackage ../mastocrom.nix {}) ];
      script = "mastocrom";
      serviceConfig.WorkingDirectory = "/var/lib/mastocrom";
    };
  };
})
