# vi: set foldmethod=marker:

{ config, pkgs, ... }:

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
      port = "leoserv";
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
  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb-6_0;
    openFirewall = true;
  };

  # ZNC {{{1
  services.znc = {
    enable = true;
    mutable = true;
    useLegacyConfig = false;
    openFirewall = true;
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
    settings = {
      homeassistant = true;
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
  # }}}
}
