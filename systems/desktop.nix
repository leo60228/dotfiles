# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = efi en_us est extra gui { autoLogin = true; } kde steam docker home kvm vfio glances flatpak mqtt cross wg { ip = "10.100.0.2"; } prometheus anbox ibus apcupsd { timeout = 300; minutes = 15; batteryLevel = 50; prometheus = "10.100.0.2"; };

  networking.firewall.allowedTCPPorts = [ 3000 34567 34568 22000 8010 6600 ];
  networking.firewall.allowedUDPPorts = [ 4010 34567 34568 21027 6600 ];

  services.postgresql = {
    enable = true;
    ensureUsers = [ {
      name = "leo60228";
      ensurePermissions = {
        "DATABASE datablase" = "ALL PRIVILEGES";
        "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
      };
    } ];
    ensureDatabases = [ "datablase" ];
  };
}
