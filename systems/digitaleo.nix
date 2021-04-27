{ pkgs, ... }: with import ../components; rec {
  components = en_us est server tailscale reverseproxy { host = "digitaleo"; };

  boot.cleanTmpDir = true;

  networking.firewall = {
    allowedTCPPorts = [ 25565 9090 80 443 ];
    allowedUDPPorts = [ 51820 443 ];
    allowPing = true;
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];

      listenPort = 51820;

      privateKeyFile = "/root/wireguard-keys/private";

      peers = [
        { # desktop
          publicKey = "9uXlgMZ+L53g8ljJwSyeudC21tQw9STuT7Uolyr6fXM=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        { # nuc
          publicKey = "emJub19Jado0vqFa5wbziMXjePHYrP8mw+ZiSf5QiUE=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
        { # router
          publicKey = "Hybix9sHznvwZJ4VCMPHDMFH00camprnXce9fKapkz4=";
          allowedIPs = [ "10.100.0.4/32" ];
        }
      ];
    };
  };

  services.prometheus = {
    enable = true;
    listenAddress = "10.100.0.1";
    port = 9090;
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [ {
          targets = [ "10.100.0.1:9090" ];
        } ];
      }
      {
        job_name = "prometheus-host";
        static_configs = [ {
          targets = [ "localhost:9100" ];
        } ];
      }
      {
        job_name = "minecraft-ping";
        scrape_interval = "5s";
        static_configs = [ {
          targets = [ "localhost:9427" ];
        } ];
      }
      {
        job_name = "desktop";
        static_configs = [ {
          targets = [ "10.100.0.2:9100" ];
        } ];
      }
      {
        job_name = "apcupsd";
        static_configs = [ {
          targets = [ "10.100.0.2:9162" ];
        } ];
      }
      {
        job_name = "nucserv";
        static_configs = [ {
          targets = [ "10.100.0.3:9100" ];
        } ];
      }
      {
        job_name = "internet";
        metrics_path = "/probe";
        scrape_interval = "5m";
        scrape_timeout = "45s";
        static_configs = [ {
          targets = [ "10.100.0.3:9516" ];
        } ];
      }
      {
        job_name = "minecraft";
        static_configs = [ {
          targets = [ "10.100.0.3:9225" ];
        } ];
      }
      {
        job_name = "router";
        static_configs = [ {
          targets = [ "10.100.0.4:9100" ];
        } ];
      }
    ];
    exporters = {
      node = {
        enable = true;
      };
    };
  };

  services.grafana = {
    addr = "0.0.0.0";
    domain = "grafana.leo60228.space";
    enable = true;
    protocol = "http";
    security.adminUser = "leo60228";
    security.adminPasswordFile = "/var/lib/grafana/grafana-password.txt";
    auth.anonymous.enable = true;
  };

  systemd.services.grafana.serviceConfig.AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];

  systemd.services.ping_exporter = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = "${pkgs.callPackage ../ping_exporter {}}/bin/ping_exporter mc.vsix.dev";
  };

  security.acme.email = "leo@60228.dev";
  security.acme.acceptTerms = true;

  systemd.services.data_expunged = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
      WorkingDirectory = "/var/lib/data_expunged";
      StandardOutput = "null";
      StandardError = "journal";
    };
    script = "${pkgs.data_expunged}/bin/data_expunged";
  };

  systemd.services.hauntbot = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
      WorkingDirectory = "/var/lib/hauntbot";
      StandardOutput = "null";
      StandardError = "journal";
    };
    script = "${pkgs.hauntbot}/bin/hauntbot";
  };

  systemd.services.minecraft-server-forwarder = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
    };
    script = "${pkgs.socat}/bin/socat TCP-LISTEN:25565,fork,reuseaddr TCP:100.115.35.128:25565";
  };
}
