{
  pkgs,
  lib,
  config,
  ...
}:
with import ../components;
rec {
  components = en_us est server tailscale reverseproxy { host = "digitaleo"; } reposilite;

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
    settings."auth.anonymous".enabled = true;
  };

  systemd.services.grafana.serviceConfig.AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];

  security.acme.defaults.email = "leo@60228.dev";
  security.acme.acceptTerms = true;

  systemd.services.minecraft-server-forwarder = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
    };
    script = "${pkgs.socat}/bin/socat TCP-LISTEN:25565,fork,reuseaddr TCP:100.115.35.128:25565";
  };

  systemd.services.fizz-strat = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
      WorkingDirectory = "/var/lib/fizz-strat";
    };
    script = "${pkgs.fizz-strat}/bin/fizz-strat";
  };

  systemd.services.searchdown = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
      WorkingDirectory = "/var/lib/searchdown";
    };
    script = "${pkgs.nodejs_20}/bin/node dist/discord.js";
  };

  systemd.services.upd8r = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
      WorkingDirectory = "/var/lib/upd8r";
    };
    script = "${pkgs.upd8r}/bin/upd8r";
  };

  services.mediawiki = {
    enable = true;
    package = pkgs.nur.repos.ihaveamac.mediawiki_1_43;
    name = "CHORDIOID Wiki";
    url = "https://chordiwiki.l3.pm";
    passwordFile = "/var/lib/mediawiki/mw-password";
    passwordSender = "chordiwiki@60228.dev";
    webserver = "nginx";
    nginx.hostName = "chordiwiki.l3.pm";

    skins.MinervaNeue = "${config.services.mediawiki.package}/share/mediawiki/skins/MinervaNeue";

    extensions = {
      WikiEditor = null;
      VisualEditor = null;
      Cite = null;
      OpenGraphMeta = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/OpenGraphMeta-REL1_43-cb990fc.tar.gz";
        hash = "sha256-oWZV2qbChUT51rpxc3p8XZ29tcHpcV7nlNK3QYgJST4=";
      };
      TimedMediaHandler = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/TimedMediaHandler-REL1_43-e157bd2.tar.gz";
        hash = "sha256-sAcE71ddEAwf1W8Tksr1nsebX52kXbcy41J3CnrJfw4=";
      };
      AbuseFilter = null;
      PageImages = null;
      Description2 = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/Description2-REL1_43-50e2aef.tar.gz";
        hash = "sha256-ciUEUcg4tsgpvohuLYztFaGNBowR7p1dIKnNp4ooKtA=";
      };
      MobileFrontend = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/MobileFrontend-REL1_43-222361c.tar.gz";
        hash = "sha256-xawcz0sLpC1xDQuOmFRUKmiGHqmscIQauWOROVxDN0w=";
      };
      ConfirmEdit = null;
    };

    extraConfig = ''
      wfLoadExtension("ConfirmEdit/QuestyCaptcha");
      $wgCaptchaQuestions = [
        "Who is the main protagonist of CHORDIOID?" => ["Sam", "Sam Mardot"],
        "What genre is CHORDIOID?" => ["Rhythm", "RPG", "Rhythm RPG"],
        "Where does CHORDIOID take place?" => ["Concordia", "Capital", "the Capital"]
      ];

      $wgLogos = [
        '1x' => "https://chordiwiki.l3.pm/chordiwiki-1x.png",
        '1.5x' => "https://chordiwiki.l3.pm/chordiwiki-1.5x.png",
        '2x' => "https://chordiwiki.l3.pm/chordiwiki-2x.png",
        'icon' => "https://chordiwiki.l3.pm/chordiwiki-icon.png"
      ];

      $wgUsePathInfo = true;

      $wgSMTP = [
        "host" => "smtp-relay.gmail.com",
        "IDHost" => "60228.dev",
        "localhost" => "60228.dev",
        "port" => 587,
        "auth" => false
      ];

      $wgMainCacheType = CACHE_ACCEL;
      $wgSessionCacheType = CACHE_DB;

      $wgFFmpegLocation = "${pkgs.ffmpeg}/bin/ffmepg";

      $wgEnableMetaDescriptionFunctions = true;

      $wgDefaultMobileSkin = "minerva";

      $wgMinervaNightMode['base'] = true;
      $wgVectorNightMode['logged_in'] = true;
      $wgVectorNightMode['logged_out'] = true;
      $wgDefaultUserOptions['vector-theme'] = 'os';
      $wgDefaultUserOptions['minerva-theme'] = 'os';

      $wgUseCdn = true;
    '';
  };
  services.phpfpm.pools.mediawiki.phpPackage = lib.mkForce (
    pkgs.php82.buildEnv {
      extensions =
        { enabled, all }:
        enabled
        ++ [
          all.opcache
          all.apcu
          all.igbinary
        ];
    }
  );
  users.users.nginx.extraGroups = [ "mediawiki" ];
}
