# vi: set foldmethod=marker:

{
  lib,
  utils,
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
  ];
  networking.firewall.allowedUDPPorts = [
    25565
    25575
    19132
    80
    443
    24454
    5353 # hass
  ];

  services.openssh.ports = [
    22
    5022
  ];

  # Minecraft {{{1
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

  # Nginx {{{1
  security.acme.defaults.email = "leo@60228.dev";
  security.acme.acceptTerms = true;

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

  # Unifi {{{1
  #services.unifi = {
  #  enable = true;
  #  unifiPackage = pkgs.unifi;
  #  mongodbPackage = pkgs.mongodb-7_0;
  #  openFirewall = true;
  #};
  virtualisation.oci-containers.containers.uosserver =
    let
      version = "4.3.6";
      imageVersion = "0.0.49";
      platform = "linux-x64";
      src = pkgs.fetchurl {
        url = "https://fw-download.ubnt.com/data/unifi-os-server/2f3a-${platform}-${version}-be3b4ae0-6bcd-435d-b893-e93da668b9d0.6-x64";
        hash = "sha256-J2f+Y2NPSTbm7B8VjGFYOt9WmuQLKCT8r6F6oAnwOfE=";
      };
      imageFile = pkgs.runCommand "image.tar" { inherit src; } ''
        ${pkgs.unzip}/bin/unzip -p $src image.tar > $out || (($?==1))
      '';
      directories = [
        "persistent"
        "var/log"
        "data"
        "srv"
        "var/lib/unifi"
        "var/lib/mongodb"
        "etc/rabbitmq/ssl"
      ];
    in
    {
      privileged = true;
      volumes = map (x: "uosserver-${utils.escapeSystemdPath x}:/${x}") directories;
      image = "uosserver:${imageVersion}";
      inherit imageFile;
      extraOptions = [ "--tz=local" ];
      ports =
        (map (x: "${toString x}:${toString x}") [
          5005
          9543
          6789
          8080
          8443
          8444
          11084
          5671
          8880
          8881
          8882
        ])
        ++ (map (x: "${toString x}:${toString x}/udp") [
          3478
          5514
          10003
        ])
        ++ [ "11443:443" ];
      environment = {
        UOS_UUID = "5adb0601-b680-5fb4-87fd-352a477e36db";
        UOS_SERVER_VERSION = version;
        FIRMWARE_PLATFORM = platform;
      };
    };

  # soju {{{1
  services.soju = {
    enable = true;
    hostName = "${config.networking.hostName}.capybara-pirate.ts.net";
    listen = [
      "irc://localhost:5002"
      "http://localhost:5003"
    ];
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
  # }}}
}
