{ config, pkgs, ... }:

with import ../components; {
  components = efi en_us est home { small = true; } tailscale znc hass unifi apcupsd-server mqtt;

  boot.enableContainers = false;

  networking.firewall.allowedTCPPorts = [ 25565 25575 19132 8443 80 443 ];
  networking.firewall.allowedUDPPorts = [ 25565 25575 19132 80 443 ];

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

  users.users.showdown = {
    home = "/var/lib/pokemon-showdown";
    group = "nogroup";
    createHome = true;
    isSystemUser = true;
    useDefaultShell = true;
  };

  #systemd.services.pokemon-showdown = {
  #  after = [ "network-online.target" ];
  #  wants = [ "network-online.target" ];
  #  wantedBy = [ "multi-user.target" ];
  #  script = "./pokemon-showdown";
  #  path = with pkgs; [ nodejs ];
  #  serviceConfig = {
  #    User = "showdown";
  #    WorkingDirectory = "/var/lib/pokemon-showdown";
  #    Restart = "always";
  #    RestartSec = 5;
  #    AmbientCapabilities = "CAP_NET_BIND_SERVICE";
  #  };
  #};

  #services.cloudflared = {
  #  enable = true;
  #  tunnels = {
  #    "e6eaa4f6-af36-4acf-be20-17c48c209744" = {
  #      credentialsFile = "/var/lib/cloudflared/e6eaa4f6-af36-4acf-be20-17c48c209744.json";
  #      default = "http_status:404";
  #      ingress."showdown.l3.pm" = "http://127.0.0.1:80";
  #    };
  #    "9c84d720-4fcf-46d5-a8b9-204a2e843f02" = {
  #      credentialsFile = "/var/lib/cloudflared/9c84d720-4fcf-46d5-a8b9-204a2e843f02.json";
  #      default = "unix:/var/run/nginx.sock";
  #    };
  #  };
  #};

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "utdr.hsmusic.wiki" = {
        default = true;
        enableACME = true;
        forceSSL = true;
        root = "/var/www/utdrmusic";
      };
    };
  };

  security.acme.defaults.email = "leo@60228.dev";
  security.acme.acceptTerms = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    ensureDatabases = [ "showdown" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
    '';
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
