{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "18.03";

  networking.firewall.allowedTCPPorts = [
    4000
    4001
    4002
  ];
  networking.firewall.allowedUDPPorts = [
    4000
    4001
    4002
  ];

  services.nfs.server = {
    enable = true;
    exports = ''
      /home 100.64.0.0/10(insecure,rw,crossmnt)
    '';
    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;
  };
}
