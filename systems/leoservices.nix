# includes = ../rawConfig.nix:../hardware/aws.nix:../components/{mailserver,en_us,est,docker,extra,shellinabox,server,gui,reverseproxy,home}.nix
{ config, pkgs, ... }: with import ../components; rec {
  #components = mailserver en_us est docker extra shellinabox server gui { audio = false; } reverseproxy { host = "aws"; } home;
  #components = en_us est docker extra shellinabox server gui { audio = false; } reverseproxy { host = "aws"; } home;
  components = en_us est docker server reverseproxy { host = "aws"; } tailscale;

  networking.firewall.allowedTCPPorts = [ 22 80 443 21 2782 5222 5269 5280 5443 ];
  networking.firewall.allowedUDPPorts = [ 2782 25565 ];

  environment.systemPackages = with pkgs; [ conspy wget vim stress ];

  #systemd.services.codeserver = {
  #  wantedBy = [ "multi-user.target" ];
  #  path = [ pkgs.docker ];
  #  script = "./codeserver.sh";
  #  serviceConfig = {
  #    User = "leo60228";
  #    WorkingDirectory = "/home/leo60228/code-server-docker";
  #  };
  #};

  systemd.services.minecraft = {
    enable = false;
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.jre8 ];
    script = "java -XX:+UseG1GC -Xmx3G -Xms3G -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -jar ./FTBserver.jar nogui";
    restartIfChanged = false; # 20 minutes later...
    serviceConfig = {
      StandardInput = "tty-force";
      TTYVHangup = "yes";
      TTYPath = "/dev/tty20";
      TTYReset = "yes";
      Restart = "always";
      User = "root";
      WorkingDirectory = "/root/minecraft";
    };
  };

  systemd.services.pds = {
    requires = [ "docker.service" ];
    after = [ "docker.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/var/lib/pds";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose --file /var/lib/pds/compose.yaml up --detach";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose --file /var/lib/pds/compose.yaml down";
    };

    wantedBy = [ "multi-user.target" ];
  };

  security.acme.certs."pds.vriska.dev" = {
    domain = "*.pds.vriska.dev";
    extraDomainNames = [ "pds.vriska.dev" ];
    dnsProvider = "cloudflare";
    credentialsFile = "/var/lib/pds/cloudflare-token";
  };

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_14;
  services.redis.servers."".enable = true;

  services.mastodon = {
    enable = true;
    enableUnixSocket = false;
    package = pkgs.leoPkgs.crabstodon;
    streamingProcesses = 1;
    extraEnvFiles = [ "/var/lib/mastodon/.extra_secrets_env" "/var/lib/mastodon/secrets/db-keys" ];
    localDomain = "60228.dev";
    smtp = {
      createLocally = false;
      host = "smtp-relay.gmail.com";
      port = 587;
      authenticate = false;
      fromAddress = "Administrator <admin@60228.dev>";
    };
    extraConfig = {
      MAX_TOOT_CHARS = "10000";
      MAX_DISPLAY_NAME_CHARS = "100";
      MAX_POLL_OPTIONS = "15";
      MAX_PROFILE_FIELDS = "15";

      GITHUB_REPOSITORY = "BlaseballCrabs/mastodon";
      SOURCE_TAG = config.services.mastodon.package.src.rev;

      UPDATE_CHECK_URL = ""; # FIXME: remove
    };
  };

  services.lemmy = {
    enable = true;
    database = {
      createLocally = true;
      uri = "postgres:///lemmy?host=/run/postgresql&user=lemmy";
    };
    settings = {
      email = {
        smtp_server = "smtp-relay.gmail.com:587";
        smtp_from_address = "Administrator <admin@60228.dev>";
        tls_type = "tls";
      };
      setup = {
        admin_username = "vriska";
        admin_password = "TeWoK25tBod2*kRz&Hq^";
        site_name = "l.60228.dev";
        admin_email = "leo@60228.dev";
      };
      hostname = "l.60228.dev";
    };
  };

  #systemd.services.ghastly = {
  #  description = "ghastly";
  #  wantedBy = [ "multi-user.target" ];
  #  after = [ "network.target" ];
  #  script = "${pkgs.callPackage ../celesters.nix {}}/bin/ghastly";
  #};

  #systemd.services.ghostbridge = {
  #  description = "ghostbridge";
  #  wantedBy = [ "multi-user.target" ];
  #  after = [ "network.target" ];
  #  script = ''
  #  export DISCORD_TOKEN="$(< /var/keys/ghostbridge-token)"
  #  ${pkgs.callPackage ../celesters.nix {}}/bin/bridge celeste.0x0ade.ga:2782
  #  '';
  #  serviceConfig.Restart = "always";
  #};

  networking.wireguard.enable = true;
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.9.0.2/32" ];
    privateKeyFile = "/var/keys/wireguard";
    peers = [
      {
        publicKey = "Y4VJQCdUnyANBWU9+Ce8E4Sjs54oycrJc9ODH84FMjo=";
        allowedIPs = [ "192.168.1.0/24" ];
        endpoint = "98.121.248.25:43331";
        persistentKeepalive = 25;
      }
    ];
  };

#  networking.firewall.extraCommands = ''
#iptables -A FORWARD -i ens5 -o wg0 -p tcp --syn --dport 25565 -m conntrack --ctstate NEW -j ACCEPT
#iptables -A FORWARD -i ens5 -o wg0 -p udp --dport 25565 -m conntrack --ctstate NEW -j ACCEPT
#iptables -A FORWARD -i ens5 -o wg0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -i wg0 -o ens5 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#iptables -t nat -A PREROUTING -i ens5 -p tcp --dport 25565 -j DNAT --to-destination 192.168.1.140
#iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 25565 -d 192.168.1.140 -j SNAT --to-source 10.9.0.2
#iptables -t nat -A PREROUTING -i ens5 -p udp --dport 25565 -j DNAT --to-destination 192.168.1.140
#iptables -t nat -A POSTROUTING -o wg0 -p udp --dport 25565 -d 192.168.1.140 -j SNAT --to-source 10.9.0.2
#
#  '';
#  boot.kernel.sysctl = {
#    "net.ipv4.conf.all.forwarding" = true;
#    "net.ipv4.conf.default.forwarding" = true;
#  };

  #services.matrix-synapse = {
  #  enable = true;
  #  server_name = "60228.dev";
  #  public_baseurl = "https://60228.dev/";
  #  listeners = [
  #    {
  #      port = 8008;
  #      bind_address = "127.0.0.1";
  #      type = "http";
  #      tls = false;
  #      x_forwarded = true;
  #      resources = [
  #        { names = [ "client" ]; compress = true; }
  #        { names = [ "federation" ]; compress = false; }
  #      ];
  #    }
  #  ];
  #  url_preview_enabled = true;
  #  extraConfig = ''
  #  suppress_key_server_warning: true
  #  '';
  #};

  #services.ejabberd = {
  #  enable = true;
  #  configFile = ../files/ejabberd.yml;
  #  imagemagick = true;
  #};

  security.acme.certs."60228.dev".group = "acme";
  users.users.nginx.extraGroups = [ "acme" ];

  #systemd.services.nginx.serviceConfig.ProtectHome = false;

  users.groups.mastodon.members = [ "nginx" ];
}
