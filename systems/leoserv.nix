{ config, pkgs, ... }:

with import ../components; {
  components = efi en_us est home { small = true; } tailscale znc;

  #networking.firewall.allowedTCPPorts = [ 25565 25575 38067 ];
  #networking.firewall.allowedUDPPorts = [ 25565 25575 38067 ];

  users.extraUsers.leo60228.extraGroups = [ "wheel" ];

  #users.users.minecraft = {
  #  home = "/var/lib/minecraft";
  #  createHome = true;
  #  isSystemUser = true;
  #};

  #systemd.services.minecraft-server = {
  #  after = [ "network-online.target" ];
  #  wants = [ "network-online.target" ];
  #  wantedBy = [ "multi-user.target" ];
  #  script = "java -XX:+UseG1GC -Xmx4G -Xms4G -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -jar /var/lib/minecraft/fabric-server-launch.jar";
  #  path = with pkgs; [ jre_headless ];
  #  serviceConfig = {
  #    User = "minecraft";
  #    WorkingDirectory = "/var/lib/minecraft";
  #  };
  #};

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
