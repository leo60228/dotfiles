{ pkgs, ... }: with import ../components; rec {
  components = en_us est docker extra cloud9 shellinabox server;

  boot.cleanTmpDir = true;

  networking.firewall.allowedTCPPorts = [ 22 80 3000 5901 5900 6080 5901 4333 21 2782 ];
  networking.firewall.allowedUDPPorts = [ 2782 ];

  # will remove once i eventually write service support into my config
  systemd.services.smsforwarder.description = "Discord.js SMS forwarder bot";
  systemd.services.smsforwarder.script = "${pkgs.nodejs-10_x}/bin/node /home/leo60228/discordsms/index.js";
  systemd.services.smsforwarder.serviceConfig.Restart = "always";
  systemd.services.smsforwarder.serviceConfig.RestartSec = 10;
  systemd.services.smsforwarder.wantedBy = [ "multi-user.target" ];

  systemd.services.celesteudp.script = "${pkgs.socat}/bin/socat udp4-listen:2782,reuseaddr,fork tcp:localhost:2783";
  systemd.services.celesteudp.serviceConfig.Restart = "always";
  systemd.services.celesteudp.serviceConfig.RestartSec = 10;
  systemd.services.celesteudp.wantedBy = [ "multi-user.target" ];

  security.sudo.extraConfig = ''
Defaults runaspw
  '';

  environment.systemPackages = [ pkgs.ppp ];
}
