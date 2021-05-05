# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = efi en_us est;

  systemd.services.minecraft = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = "leo60228";
      Restart = "always";
      RestartSec = 5;
      StartLimitIntervalSec = 60;
      StartLimitBurst = 3;
      WorkingDirectory = "/var/lib/minecraft";
      MemoryHigh = "3.6G";
      MemoryMax = "4G";
      CPUQuota = "300%";
    };
    path = [ pkgs.openjdk14 ];
    script = "./run.sh";
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];
  networking.firewall.allowedUDPPorts = [ 25565 ];
}
