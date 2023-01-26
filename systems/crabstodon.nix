{ config, pkgs, ... }: with import ../components; rec {
  components = en_us efi est server tailscale;

  boot.cleanTmpDir = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.mastodon = {
    enable = true;
    package = pkgs.leoPkgs.crabstodon;

    localDomain = "crabs.life";

    smtp = {
      createLocally = false;
      fromAddress = "no-reply@social.crabs.life";

      host = "smtp.mailgun.org";
      port = 587;
      user = "postmaster@social.crabs.life";
      passwordFile = "/var/lib/mastodon/secrets/smtp-password";
      authenticate = true;
    };

    elasticsearch.host = "localhost";

    extraConfig = {
      WEB_DOMAIN = "social.crabs.life";
      CDN_HOST = "https://assets.crabs.life";
      S3_ALIAS_HOST = "files.crabs.life";

      S3_ENABLED = "true";
      S3_BUCKET = "crabstodon-user-content";
      S3_REGION = "us-east-1";
      S3_ENDPOINT = "https://idpkbyow62bg.compat.objectstorage.us-ashburn-1.oraclecloud.com";
      S3_HOSTNAME = "idpkbyow62bg.compat.objectstorage.us-ashburn-1.oraclecloud.com";

      MAX_TOOT_CHARS = "10000";
      MAX_DISPLAY_NAME_CHARS = "100";
      MAX_POLL_OPTIONS = "15";

      GITHUB_REPOSITORY = "BlaseballCrabs/mastodon";
      SOURCE_TAG = config.services.mastodon.package.src.src.rev;
    };
  };

  services.postgresql.package = pkgs.postgresql_14;

  services.elasticsearch = {
    enable = true;
    package = pkgs.elasticsearch7;
    extraConf = "xpack.security.enabled: false"; # not allowed in firewall anyway
  };

  systemd.services.mastodon-init-dirs.postStart = ''
  cat /var/lib/mastodon/.extra_secrets_env >> /var/lib/mastodon/.secrets_env
  '';

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    appendHttpConfig = ''
    proxy_cache_path /var/cache/nginx keys_zone=CACHE:10m;
    '';

    virtualHosts = {
      "social.crabs.life" = {
        root = "${config.services.mastodon.package}/public/";
        forceSSL = true;
        enableACME = true;

        locations."/system/".alias = "/var/lib/mastodon/public-system/";

        locations."/" = {
          tryFiles = "$uri @proxy";
        };

        locations."@proxy" = {
          proxyPass = "http://unix:/run/mastodon-web/web.socket";
          proxyWebsockets = true;
        };

        locations."/api/v1/streaming/" = {
          proxyPass = "http://unix:/run/mastodon-streaming/streaming.socket";
          proxyWebsockets = true;
        };
      };

      "assets.crabs.life" = {
        root = "${config.services.mastodon.package}/public/";
        forceSSL = true;
        enableACME = true;

        extraConfig = ''
        add_header 'Access-Control-Allow-Origin' '*';
        '';
      };

      "files.crabs.life" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          extraConfig = ''
          limit_except GET {
            deny all;
          }

          proxy_set_header Host idpkbyow62bg.compat.objectstorage.us-ashburn-1.oraclecloud.com;
          proxy_set_header Connection "";
          proxy_set_header Authorization "";
          proxy_hide_header Set-Cookie;
          proxy_hide_header 'Access-Control-Allow-Origin';
          proxy_hide_header 'Access-Control-Allow-Methods';
          proxy_hide_header 'Access-Control-Allow-Headers';
          proxy_hide_header x-amz-id-2;
          proxy_hide_header x-amz-request-id;
          proxy_hide_header x-amz-meta-server-side-encryption;
          proxy_hide_header x-amz-server-side-encryption;
          proxy_hide_header x-amz-bucket-region;
          proxy_hide_header x-amzn-requestid;
          proxy_ignore_headers Set-Cookie;
          proxy_intercept_errors off;

          proxy_cache CACHE;
          proxy_cache_valid 200 48h;
          proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
          proxy_cache_lock on;

          expires 1y;
          add_header Cache-Control public;
          add_header 'Access-Control-Allow-Origin' '*';
          add_header X-Cache-Status $upstream_cache_status;
          '';
          proxyPass = "https://idpkbyow62bg.compat.objectstorage.us-ashburn-1.oraclecloud.com/crabstodon-user-content/";
        };
      };
    };
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "leo-acme@60228.dev";

  users.groups.mastodon.members = [ "nginx" ];
}
