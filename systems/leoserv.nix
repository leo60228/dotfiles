{ config, pkgs, ... }:

with import ../components;
{
  components = efi en_us est home { small = true; } tailscale hass;

  boot.enableContainers = false;

  networking.firewall.allowedTCPPorts = [
    25565
    25575
    19132
    8443
    80
    443
    3551 # apcupsd
    1883 # mqtt
  ];
  networking.firewall.allowedUDPPorts = [
    25565
    25575
    19132
    80
    443
    24454
  ];

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
    restartIfChanged = false;
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
    commonHttpConfig = ''
      ssl_ecdh_curve X25519MLKEM768:X25519:prime256v1:secp521r1:secp384r1;
    '';
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

  #services.borgbackup.jobs."leoserv-modfest" = {
  #  paths = [ "/var/lib/minecraft" ];
  #  repo = "de3482s2@de3482.rsync.net:leoserv-modfest";
  #  encryption = {
  #    mode = "repokey-blake2";
  #    passCommand = "cat /root/borgbackup/passphrase";
  #  };
  #  environment.BORG_RSH = "ssh -i /root/borgbackup/ssh_key";
  #  environment.BORG_REMOTE_PATH = "borg1";
  #  compression = "auto,lzma";
  #  startAt = "hourly";
  #  prune.keep = {
  #    within = "1d";
  #    daily = 7;
  #    weekly = 4;
  #    monthly = -1;
  #  };
  #};

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.user == "minecraft" &&
          action.id == "org.freedesktop.systemd1.manage-units") {
        var unit = action.lookup("unit");
        if (unit == "minecraft-server.service" || unit == "borgbackup-job-leoserv-modfest.service")
          return polkit.Result.YES;
      }
    });
  '';

  services.openssh = {
    ports = [
      22
      5022
    ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  virtualisation.oci-containers.containers.actual = {
    pull = "newer";
    ports = [ "127.0.0.1:5006:5006" ];
    volumes = [ "actual:/data" ];
    image = "ghcr.io/actualbudget/actual:latest-alpine";
    extraOptions = [ "--tz=local" ];
  };

  # apcupsd
  services.apcupsd = {
    enable = true;
    configText = ''
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
      UPSCLASS standalone
      UPSMODE disable
      NETSERVER on
    '';
  };

  # mqtt
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = "0.0.0.0";
        settings.allow_anonymous = true;
        omitPasswordAuth = true;
        acl = [
          "topic readwrite #"
          "user DVES_USER"
          "topic readwrite #"
        ];
      }
    ];
  };

  # unifi
  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb-6_0;
    openFirewall = true;
  };

  # znc
  services.znc = {
    enable = true;
    mutable = true;
    useLegacyConfig = false;
    openFirewall = true;
  };
}
