# vi: set foldmethod=marker:

{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "18.03";
  boot.enableContainers = false;

  # Networking {{{1
  networking.firewall.allowedTCPPorts = [
    25565
    25575
    19132
    8443
    80
    443
    3551 # apcupsd
    1883 # mqtt
    8123 # hass
    21063 # hass
    34197
    8300
    113
    21115 # rustdesk
    21116 # rustdesk
    21117 # rustdesk
    30005 # dump1090-fa
  ];
  networking.firewall.allowedUDPPorts = [
    25565
    25575
    19132
    80
    443
    24454
    5353 # hass
    34197
    21116 # rustdesk
  ];

  services.openssh.ports = [
    22
    5022
  ];

  # Archipelago {{{1
  users.users.archipelago = {
    home = "/var/lib/archipelago";
    group = "nogroup";
    createHome = true;
    isSystemUser = true;
    useDefaultShell = true;
  };

  environment.systemPackages = [
    pkgs.archipelago
    pkgs.factorio-headless
    pkgs.expect
  ];
  environment.pathsToLink = [ "/share/factorio" ];

  systemd.services.archipelago-server = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    script = "./start.sh";
    restartIfChanged = false;
    serviceConfig = {
      User = "archipelago";
      WorkingDirectory = "/var/lib/archipelago";
      Restart = "always";
      RestartSec = 5;
    };
  };

  # Nginx {{{1
  security.acme.defaults.email = "leo@60228.dev";
  security.acme.acceptTerms = true;

  services.nginx = {
    enable = true;
    commonHttpConfig = ''
      ssl_ecdh_curve X25519MLKEM768:X25519:prime256v1:secp384r1;
    '';
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
      "rustdesk.l3.pm" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/".return = 444;
          "/ws/id" = {
            proxyPass = "http://127.0.0.1:21118";
            proxyWebsockets = true;
          };
          "/ws/relay" = {
            proxyPass = "http://127.0.0.1:21119";
            proxyWebsockets = true;
          };
        };
      };
    };
  };

  # Inadyn {{{1
  systemd.services.inadyn = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = "${pkgs.inadyn}/bin/inadyn --foreground --syslog -f /root/inadyn.conf";
  };

  # apcupsd {{{1
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

  power.ups = {
    enable = true;
    mode = "netserver";
    ups.apcupsd = {
      driver = "apcupsd-ups";
      port = "greenhouse";
    };
    upsd.listen = [ { address = "0.0.0.0"; } ];
    upsmon.settings.MINSUPPLIES = 0;
  };

  # mqtt {{{1
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

  # soju {{{1
  services.soju = {
    enable = true;
    hostName = "${config.networking.hostName}.capybara-pirate.ts.net";
    listen = [
      "irc://localhost:5002"
      "http://localhost:5003"
      "ident://[::]"
    ];
    extraConfig = ''
      http-ingress https://${config.networking.hostName}.capybara-pirate.ts.net:5001
      file-upload http http://localhost:40413/upload
    '';
  };
  systemd.services.soju = {
    environment.GODEBUG = "tlsrsakex=1"; # eyeroll
    serviceConfig = {
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
    };
  };

  systemd.services.filehost-elixire = {
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    script = "${pkgs.leoPkgs.filehost-elixire}/bin/filehost-elixire";
    environment.APIKEY_PATH = "%d/apikey";
    serviceConfig = {
      Restart = "always";
      DynamicUser = true;
      LoadCredential = "apikey:/var/lib/elixire-apikey";
    };
  };

  # hass {{{1
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers.homeassistant = {
    volumes = [ "home-assistant:/config" ];
    image = "ghcr.io/home-assistant/home-assistant:stable";
    extraOptions = [
      "--privileged"
      "--network=host"
      "--pull=newer"
      "--tz=local"
    ];
  };
  virtualisation.oci-containers.containers.wyoming-faster-whisper = {
    pull = "newer";
    ports = [ "127.0.0.1:10300:10300" ];
    volumes = [ "wyoming-faster-whisper:/data" ];
    image = "docker.io/rhasspy/wyoming-whisper:latest";
    cmd = [ "--language=en" ];
  };
  virtualisation.oci-containers.containers.wyoming-piper = {
    pull = "newer";
    ports = [ "127.0.0.1:10200:10200" ];
    volumes = [ "wyoming-piper:/data" ];
    image = "docker.io/rhasspy/wyoming-piper:latest";
    cmd = [ "--voice=en_US-lessac-medium" ];
  };

  services.zigbee2mqtt = {
    enable = true;
    package = pkgs.zigbee2mqtt_2;
    settings = {
      homeassistant.enabled = true;
      serial.adapter = "zstack";
      serial.port = "/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_a0b342a38245ed119082c68f0a86e0b4-if00-port0";
      frontend.port = 8456;
      advanced.network_key = "!secret network_key";
      mqtt.server = "mqtt://127.0.0.1";
      groups = "groups.yaml";
    };
  };

  # Actual {{{1
  virtualisation.oci-containers.containers.actual = {
    pull = "newer";
    ports = [ "127.0.0.1:5006:5006" ];
    volumes = [ "actual:/data" ];
    image = "ghcr.io/actualbudget/actual:latest-alpine";
    extraOptions = [ "--tz=local" ];
  };

  virtualisation.oci-containers.containers.actualtap = {
    pull = "newer";
    ports = [ "127.0.0.1:3001:3001" ];
    image = "ghcr.io/mattfaz/actualtap:latest";
    dependsOn = [ "actual" ];
    environment.ACTUAL_URL = "http://actual:5006";
    environmentFiles = [ "/var/lib/actualtap.env" ];
    extraOptions = [ "--tz=local" ];
  };

  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  # RIPE Atlas Probe {{{1
  virtualisation.oci-containers.containers.ripe-atlas = {
    image = "docker.io/jamesits/ripe-atlas:latest";
    volumes = [
      "/etc/ripe-atlas:/etc/ripe-atlas"
      "/run/ripe-atlas:/run/ripe-atlas"
      "/var/spool/ripe-atlas:/var/spool/ripe-atlas"
    ];
    environment.HTTP_POST_PORT = "8028";
    privileged = true;
    extraOptions = [
      "--network=host"
      "--tz=local"
    ];
    pull = "newer";
    labels."io.containers.autoupdate" = "registry";
  };

  systemd.services.podman-ripe-atlas.after = lib.mkAfter [ "systemd-tmpfiles-setup.service" ];

  systemd.timers.podman-auto-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnUnitActiveSet = "10m";
      Unit = "podman-auto-update.service";
    };
  };

  systemd.tmpfiles.settings = {
    "10-ripe-atlas" =
      let
        settings = {
          d = {
            group = "999";
            mode = "0755";
            user = "101";
          };
        };
      in
      {
        "/etc/ripe-atlas" = settings;
        "/run/ripe-atlas" = settings;
        "/var/spool/ripe-atlas" = settings;
      };
  };

  # Nextcloud {{{1
  services.nextcloud = {
    enable = true;
    hostName = "nextcloud.l3.pm";
    package = pkgs.nextcloud35;
    config.dbtype = "sqlite";
    https = true;
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  # RustDesk {{{1
  services.rustdesk-server = {
    enable = true;
    signal.relayHosts = [ "rustdesk.l3.pm" ];
  };

  # ADS-B {{{1
  hardware.rtl-sdr.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="2838", TAG+="systemd", ENV{SYSTEMD_WANTS}+="readsb.service"
  '';

  systemd.services.readsb.script = ''
    exec ${lib.getExe' pkgs.readsb "readsb"} \
      --quiet \
      --net --net-bo-port 30005 \
      --device-type rtlsdr --gain auto \
      $(< /var/lib/readsb.conf)
  '';

  systemd.services.mlat-client = {
    wantedBy = [ "readsb.service" ];
    after = [ "readsb.service" ];
    script = ''
      exec ${lib.getExe pkgs.leoPkgs.mlat-client} \
        --input-type dump1090 \
        --input-connect localhost:30005 \
        $(< /var/lib/mlat-client.conf)
    '';
  };

  virtualisation.oci-containers.containers.piaware = {
    pull = "newer";
    image = "ghcr.io/sdr-enthusiasts/docker-piaware:latest";
    environment = {
      RECEIVER_TYPE = "relay";
      BEASTHOST = "host.containers.internal";
      BEASTPORT = "30005";
    };
    ports = [ "127.0.0.1:30080:80" ];
    environmentFiles = [ "/var/lib/piaware.env" ];
    extraOptions = [ "--tz=local" ];
    labels."io.containers.autoupdate" = "registry";
  };

  virtualisation.oci-containers.containers.fr24feed = {
    pull = "newer";
    image = "ghcr.io/sdr-enthusiasts/docker-flightradar24:latest";
    environment.BEASTHOST = "host.containers.internal";
    ports = [ "127.0.0.1:8754:8754" ];
    environmentFiles = [ "/var/lib/fr24feed.env" ];
    extraOptions = [ "--tz=local" ];
    labels."io.containers.autoupdate" = "registry";
  };
  # }}}
}
