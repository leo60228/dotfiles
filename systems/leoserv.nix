{ config, pkgs, ... }:

with import ../components; {
  components = efi en_us est home { small = true; } tailscale znc hass unifi apcupsd-server mqtt;

  networking.firewall.allowedTCPPorts = [ 25565 25575 19132 ];
  networking.firewall.allowedUDPPorts = [ 25565 25575 19132 ];

  users.extraUsers.leo60228.extraGroups = [ "wheel" ];

  users.users.minecraft = {
    home = "/var/lib/minecraft";
    group = "nogroup";
    createHome = true;
    isSystemUser = true;
    useDefaultShell = true;
  };

  systemd.services.minecraft-server = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    script = "./ServerStart.sh";
    path = with pkgs; [ jre ];
    serviceConfig = {
      User = "minecraft";
      WorkingDirectory = "/var/lib/minecraft";
      Restart = "always";
      RestartSec = 5;
    };
  };

  #systemd.services.serversync = {
  #  after = [ "network-online.target" ];
  #  wants = [ "network-online.target" ];
  #  wantedBy = [ "multi-user.target" ];
  #  script = "java -jar serversync-3.6.0-all.jar --server";
  #  path = with pkgs; [ jre_headless ];
  #  serviceConfig = {
  #    User = "minecraft";
  #    WorkingDirectory = "/var/lib/minecraft";
  #  };
  #};

  systemd.services.inadyn = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = "${pkgs.inadyn}/bin/inadyn --foreground --syslog -f /root/inadyn.conf";
  };

  networking.dhcpcd.extraConfig = ''
  static domain_name_servers=100.100.100.100 79.110.170.43 1.1.1.1 1.0.0.1
  static domain_search=60228.dev.beta.tailscale.net
  '';
}
