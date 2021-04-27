{ config, pkgs, ... }:

with import ../components; {
  components = efi en_us est home { small = true; } tailscale znc;

  networking.firewall.allowedTCPPorts = [ 25565 25575 ];
  networking.firewall.allowedUDPPorts = [ 25565 25575 ];

  users.extraUsers.leo60228.extraGroups = [ "wheel" ];

  users.users.minecraft = {
    home = "/var/lib/minecraft";
    createHome = true;
    isSystemUser = true;
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

  #services.ddclient = {
  #  enable = true;
  #  domains = [ "vsix-modded-mc" ];
  #  protocol = "duckdns";
  #};

  networking.dhcpcd.extraConfig = ''
  static domain_name_servers=100.100.100.100 79.110.170.43 1.1.1.1 1.0.0.1
  static domain_search=60228.dev.beta.tailscale.net
  '';
}
