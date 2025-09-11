# vi: set foldmethod=marker:

{
  pkgs,
  lib,
  config,
  ...
}:
rec {
  imports = [
    ./hardware.nix
    ./prometheus.nix
    ./mediawiki.nix
  ];

  system.stateVersion = "18.03";
  boot.enableContainers = false;

  # Nginx {{{1
  security.acme = {
    defaults.email = "leo@60228.dev";
    acceptTerms = true;
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "50m";
    commonHttpConfig = ''
      log_format full '$remote_addr - $remote_user [$time_local] '
                      '"$request" $status $bytes_sent '
                      '"$http_referer" "$http_user_agent"';
    '';
  };

  # Networking {{{1
  networking.firewall = {
    allowedTCPPorts = [
      24872
      25565
      9090
      80
      443
    ];
    allowedUDPPorts = [
      24872
      51820
      443
    ];
    allowPing = true;
  };

  services.tailscale.useRoutingFeatures = "both";

  # Miscellaneous Services {{{1
  # minecraft-server-forwarder {{{2
  systemd.services.minecraft-server-forwarder = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
    };
    script = "${pkgs.socat}/bin/socat TCP-LISTEN:25565,fork,reuseaddr TCP:100.115.35.128:25565";
  };

  # fizz-strat {{{2
  systemd.services.fizz-strat = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
      WorkingDirectory = "/var/lib/fizz-strat";
    };
    script = "${pkgs.fizz-strat}/bin/fizz-strat";
  };

  # upd8r {{{2
  systemd.services.upd8r = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
      WorkingDirectory = "/var/lib/upd8r";
    };
    script = "${pkgs.upd8r}/bin/upd8r";
  };

  # Searchdown {{{1
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      searchdown = {
        image = "registry.gitlab.com/arachnidsGrip/searchdown:latest";
        environmentFiles = [ "/var/lib/searchdown/.env" ];
        extraOptions = [
          "--label=io.containers.autoupdate=registry"
          "--pull=newer"
        ];
      };
    };
  };

  systemd.timers.podman-auto-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnUnitActiveSet = "10m";
      Unit = "podman-auto-update.service";
    };
  };

  # Reposilite {{{1
  systemd.services.reposilite = {
    wantedBy = [ "multi-user.target" ];

    script = "${pkgs.leoPkgs.reposilite}/bin/reposilite -lc /etc/reposilite/reposilite.cdn -wd /var/lib/reposilite";

    serviceConfig = {
      TimeoutStopSec = 10;
      Restart = "on-failure";
      RestartSec = 5;
      DynamicUser = true;
      StateDirectory = "reposilite";
      ConfigurationDirectory = "reposilite";
      WorkingDirectory = "/var/lib/reposilite";
    };
  };

  services.nginx.virtualHosts."maven.vriska.dev" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:8080";
      proxyWebsockets = true;
    };
  };
  # }}}
}
