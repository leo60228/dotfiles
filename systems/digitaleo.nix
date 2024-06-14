{ pkgs, lib, ... }: with import ../components; rec {
  components = en_us est server tailscale reverseproxy { host = "digitaleo"; } reposilite;

  networking.firewall = {
    allowedTCPPorts = [ 24872 25565 9090 80 443 ];
    allowedUDPPorts = [ 24872 51820 443 ];
    allowPing = true;
  };

  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
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

  systemd.services.citra-room = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Restart = "on-failure";
    };
    script = ''
    ${pkgs.leoPkgs.citra}/bin/citra-room --room-name 'USA East - Pokémon Ultra Sun and Ultra Moon - vriska' --preferred-game 'Pokémon Ultra Sun' --preferred-game-id '00040000001B5000' --ban-list-file /var/lib/citra-banlist
    '';
  };

  services.mediawiki = {
    enable = true;
    name = "COAL Wiki";
    url = "https://coal.l3.pm";
    passwordFile = "/var/lib/mediawiki/mw-password";
    passwordSender = "coal-wiki@60228.dev";
    webserver = "none";

    skins.MinervaNeue = "${pkgs.mediawiki}/share/mediawiki/skins/MinervaNeue";

    extensions = {
      WikiEditor = null;
      VisualEditor = null;
      Cite = null;
      OpenGraphMeta = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/OpenGraphMeta-REL1_39-097f601.tar.gz";
        sha256 = "0kfxrcckvq5h8n3pfapy6nxzm36axwf57cw50g2j835rrb1q3kwj";
      };
      TimedMediaHandler = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/TimedMediaHandler-REL1_39-fedcb2d.tar.gz";
        sha256 = "1c4k0xzfyy1r4jpk981393z4f7gg7ri5h7dj9f0qk2ai3l7czrlq";
      };
      AbuseFilter = null;
      PageImages = null;
      Description2 = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/Description2-REL1_39-6fd7aff.tar.gz";
        sha256 = "1796vds3s9ll2qasldd59biqgypxkpq9d80dnp8pp4g89llyg03j";
      };
      MobileFrontend = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/MobileFrontend-REL1_39-f766e58.tar.gz";
        sha256 = "18alf9ax09qw5rgb8icmr80lg2h39lg77x9afji8g2iwv5rhn75m";
      };
      ConfirmEdit = null;
    };

    extraConfig = ''
    wfLoadExtension("ConfirmEdit/QuestyCaptcha");
    $wgCaptchaQuestions = [
      "Who is the main protagonist of COAL?" => ["Ash", "Ash Ketchum"],
      "Who wrote the cribsheet?" => "Mew",
      "What's the first region in COAL?" => "Kanto",
      "What's the second (sub)region in COAL?" => "Orange Islands"
    ];

    $wgLogo = "https://cdn.discordapp.com/icons/904408350475825225/e8d9b1f74955497368c5105257c7a2c6.png?size=256";

    $wgUsePathInfo = true;
    $wgArticlePath = "/$1";

    $wgSMTP = [
      "host" => "smtp-relay.gmail.com",
      "IDHost" => "60228.dev",
      "localhost" => "60228.dev",
      "port" => 587,
      "auth" => false
    ];

    $wgFFmpegLocation = "${pkgs.ffmpeg}/bin/ffmepg";
    $wgEnableMetaDescriptionFunctions = true;
    $wgDefaultMobileSkin = "minerva";
    '';
  };
  users.users.nginx.extraGroups = [ "mediawiki" ];
}
