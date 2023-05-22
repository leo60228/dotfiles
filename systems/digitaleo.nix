{ pkgs, ... }: with import ../components; rec {
  components = en_us est server tailscale reverseproxy { host = "digitaleo"; };

  networking.firewall = {
    allowedTCPPorts = [ 25565 9090 80 443 ];
    allowedUDPPorts = [ 51820 443 ];
    allowPing = true;
  };

  services.prometheus = {
    enable = true;
    listenAddress = "100.84.68.17";
    port = 9090;
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [ {
          targets = [ "100.84.68.17:9090" ];
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
          targets = [ "100.70.195.127:9100" ];
        } ];
      }
      {
        job_name = "apcupsd";
        static_configs = [ {
          targets = [ "100.70.195.127:9162" ];
        } ];
      }
      {
        job_name = "nucserv";
        static_configs = [ {
          targets = [ "100.98.216.28:9100" ];
        } ];
      }
      {
        job_name = "internet";
        metrics_path = "/probe";
        scrape_interval = "5m";
        scrape_timeout = "45s";
        static_configs = [ {
          targets = [ "100.98.216.28:9516" ];
        } ];
      }
      {
        job_name = "minecraft";
        static_configs = [ {
          targets = [ "100.98.216.28:9225" ];
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
    enable = true;
    settings.server.http_addr = "0.0.0.0";
    settings.server.domain = "grafana.leo60228.space";
    settings.server.protocol = "http";
    settings.security.admin_user = "leo60228";
    settings.security.admin_password = "$__file{/var/lib/grafana/grafana-password.txt}";
    settings."auth.anonymous".enabled = true;
  };

  systemd.services.grafana.serviceConfig.AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];

  systemd.services.ping_exporter = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = "${pkgs.leoPkgs.ping_exporter}/bin/ping_exporter mc.vsix.dev";
  };

  security.acme.email = "leo@60228.dev";
  security.acme.acceptTerms = true;

  systemd.services.minecraft-server-forwarder = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
    };
    script = "${pkgs.socat}/bin/socat TCP-LISTEN:25565,fork,reuseaddr TCP:100.115.35.128:25565";
  };
}
