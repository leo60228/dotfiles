{
  config,
  pkgs,
  lib,
  ...
}:
with import ../components;
rec {
  components = server tailscale;

  system.stateVersion = "18.03";

  networking.firewall.allowedTCPPorts = [
    80
    443
    9200
    5601
  ];

  services.mastodon = {
    enable = true;
    package = pkgs.leoPkgs.crabstodon;

    streamingProcesses = 3;

    localDomain = "crabs.life";

    smtp = {
      createLocally = false;
      fromAddress = "no-reply@social.crabs.life";

      host = "smtp-relay.gmail.com";
      port = 587;
      authenticate = false;
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

      SMTP_AUTH_METHOD = "none";

      MAX_TOOT_CHARS = "10000";
      MAX_DISPLAY_NAME_CHARS = "100";
      MAX_POLL_OPTIONS = "15";

      GITHUB_REPOSITORY = "BlaseballCrabs/mastodon";
      SOURCE_TAG = config.services.mastodon.package.src.rev;
    };
  };

  services.postgresql.package = pkgs.postgresql_14;

  services.elasticsearch = {
    enable = true;
    package = pkgs.elasticsearch7;
    extraConf = ''
      xpack.security.enabled: true
      xpack.security.transport.ssl.enabled: true
      xpack.security.transport.ssl.verification_mode: certificate
      xpack.security.transport.ssl.client_authentication: required
      xpack.security.transport.ssl.keystore.path: elastic-certificates.p12
      xpack.security.transport.ssl.truststore.path: elastic-certificates.p12
      http.bind_host: ["_local_", "_tailscale0_"]
      http.publish_host: "_tailscale0_"
    '';
  };

  systemd.services.elasticsearch.postStart = lib.mkForce ''
    # Make sure elasticsearch is up and running before dependents
    # are started
    while ! ${pkgs.curl}/bin/curl -sS http://localhost:9200 2>/dev/null; do
      sleep 1
    done
  '';

  #services.kibana = {
  #  enable = true;
  #  listenAddress = "crabstodon.capybara-pirate.ts.net";
  #  elasticsearch = {
  #    username = "kibana_system";
  #    password = "\${ES_PASS}";
  #    certificateAuthorities = [];
  #  };
  #  extraConf = {
  #    xpack.encryptedSavedObjects.encryptionKey = "\${ESO_KEY}";
  #    xpack.reporting.encryptionKey = "\${REPORTING_KEY}";
  #    xpack.security.encryptionKey = "\${SECURITY_KEY}";
  #  };
  #};

  nixpkgs.config.permittedInsecurePackages = [ "nodejs-16.20.2" ];

  #systemd.services.kibana.serviceConfig.EnvironmentFile = "/var/lib/kibana/.secrets_env";

  systemd.services.mastodon-init-dirs.postStart = ''
    cat /var/lib/mastodon/.extra_secrets_env >> /var/lib/mastodon/.secrets_env
  '';

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;

    commonHttpConfig = ''
      ssl_ecdh_curve X25519MLKEM768:X25519:prime256v1:secp521r1:secp384r1;
    '';

    appendHttpConfig = ''
      proxy_cache_path /var/cache/nginx keys_zone=CACHE:10m;
    '';

    virtualHosts = {
      ".social.crabs.life" = {
        root = "${config.services.mastodon.package}/public/";
        forceSSL = true;
        useACMEHost = "social.crabs.life";

        locations."/system/".alias = "/var/lib/mastodon/public-system/";

        locations."/" = {
          tryFiles = "$uri @proxy";
          recommendedProxySettings = false;
        };

        locations."@proxy" = {
          proxyPass = "http://unix:/run/mastodon-web/web.socket";
          proxyWebsockets = true;
          recommendedProxySettings = false;

          extraConfig = ''
            proxy_set_header Host social.crabs.life;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };

        locations."/api/v1/streaming/" = {
          proxyPass = "http://mastodon-streaming";
          proxyWebsockets = true;
          recommendedProxySettings = false;

          extraConfig = ''
            proxy_set_header Host social.crabs.life;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
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
    upstreams.mastodon-streaming = {
      extraConfig = ''
        least_conn;
      '';
      servers = builtins.listToAttrs (
        map (i: {
          name = "unix:/run/mastodon-streaming/streaming-${toString i}.socket";
          value = { };
        }) (lib.range 1 config.services.mastodon.streamingProcesses)
      );
    };
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "leo-acme@60228.dev";
  security.acme.certs."social.crabs.life" = {
    domain = "*.social.crabs.life";
    extraDomainNames = [ "social.crabs.life" ];
    dnsProvider = "cloudflare";
    credentialsFile = "/var/lib/mastodon/cloudflare-token";
    group = "nginx";
  };

  users.groups.mastodon.members = [ "nginx" ];
}
