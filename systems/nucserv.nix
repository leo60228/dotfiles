# includes = ../rawConfig.nix:../hardware/desktop.nix:../components/{efi,en_us,est,extra,gui,kde,steam,docker,home,vfio}.nix

{ config, pkgs, lib, ... }:

with import ../components; rec {
  components = efi en_us est home { small = true; } prometheus tailscale;
  services.openssh.forwardX11 = true;

  users.extraUsers.minecraft = {
    isSystemUser = true;
    createHome = true;
    home = "/var/lib/minecraft";
    useDefaultShell = true;
    group = "minecraft";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDONVMstvklgtmy9T5J2UGnYJ58lRSA3mlxQafUZEMVIICx7oSyasvdQKDfWXxaTu64xuzx4KtsdVYQrvzPdCCVm9zTuIL/8fISBtntcliTTiK6Mu4dVq9BdRQrZGTUIzQbRpbLov4ZF9keaEtfQDyXLdcOQwiXIHBTwuByQHa9J5RPWdtYfxfJazOa8Z7dl0zroSwRUx1mg+t1UdfO0NE+CEjwoGIIMdf/AVSkyDWH4ehxZhP/gzbvrNvDEw+TfwxXOZurqfnrDr1sQncre5mA2HE2HB/Pbis5j+PB3fUST8R7sjrXQK0S2XBwiG4kzYDUhUwSFBCGPQr/FTELs1CzYWSEyQ/Hwfp5HNvA8L6Tc0JIR2RUlZyhc2fr9AhSY1zM55CU3vKqmw9hek4mMFiZXrN5LQcQCPPDSaD6KRUvZtHFWvJ4oDwq2szx+yn7lrB+tZkI77azVJ4BrBSgVhwTLXUMSasjRSHhD/PAwo2HV+Z0ErlYCucUWMPN3t43ZT0= ally@Invision"
    ];
  };
  users.extraGroups.minecraft = {};

  systemd.services.minecraft = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      User = "minecraft";
      Restart = "always";
      RestartSec = 5;
      StartLimitIntervalSec = 60;
      StartLimitBurst = 3;
      WorkingDirectory = "/var/lib/minecraft";
      MemoryHigh = "4.6G";
      MemoryMax = "5G";
      CPUQuota = "300%";
    };
    path = [ pkgs.adoptopenjdk-jre-hotspot-bin-16 ];
    script = "./run.sh";
  };

  networking.firewall.allowedTCPPorts = [ 25565 9516 9225 8096 8920 80 443 4001 ];
  networking.firewall.allowedUDPPorts = [ 25565 19132 1900 7359 4001 ];

  services.ddclient = {
    enable = true;
    configFile = "/root/ddclient.conf";
  };

  services.openssh.passwordAuthentication = false;

  security.polkit.extraConfig = ''
  polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "minecraft.service" &&
          subject.user == "minecraft") {
          return polkit.Result.YES;
      }
  });
  '';

  networking.hostName = "nucserv";
}
