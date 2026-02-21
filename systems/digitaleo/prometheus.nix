{ pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 9090;
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [ { targets = [ "100.84.68.17:9090" ]; } ];
      }
      {
        job_name = "prometheus-host";
        static_configs = [ { targets = [ "localhost:9100" ]; } ];
      }
      {
        job_name = "minecraft-ping";
        scrape_interval = "5s";
        static_configs = [ { targets = [ "localhost:9427" ]; } ];
      }
      {
        job_name = "desktop";
        static_configs = [ { targets = [ "100.70.195.127:9100" ]; } ];
      }
      {
        job_name = "apcupsd";
        static_configs = [ { targets = [ "100.70.195.127:9162" ]; } ];
      }
      {
        job_name = "nucserv";
        static_configs = [ { targets = [ "100.98.216.28:9100" ]; } ];
      }
      {
        job_name = "internet";
        metrics_path = "/probe";
        scrape_interval = "5m";
        scrape_timeout = "45s";
        static_configs = [ { targets = [ "100.98.216.28:9516" ]; } ];
      }
      {
        job_name = "minecraft";
        static_configs = [ { targets = [ "100.98.216.28:9225" ]; } ];
      }
    ];
    exporters = {
      node = {
        enable = true;
      };
      ping = {
        enable = true;
        settings.targets = [ "mc.vsix.dev" ];
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
    settings.security.secret_key = "SW2YcwTIb9zpOOhoPsMm";
    settings."auth.anonymous".enabled = true;
  };

  systemd.services.grafana.serviceConfig.AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];

  services.nginx.virtualHosts."grafana.leo60228.space" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://localhost:3000";
    };
  };
}
