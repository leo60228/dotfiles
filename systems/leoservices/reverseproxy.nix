{
  pkgs,
  config,
  lib,
  ...
}:
{
  security.acme = {
    defaults.email = "leo@60228.dev";
    acceptTerms = true;
  };

  services.nginx = lib.mkForce {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    commonHttpConfig = ''
      log_format full '$remote_addr - $remote_user [$time_local] '
                      '"$request" $status $bytes_sent '
                      '"$http_referer" "$http_user_agent"';
    '';
    virtualHosts = {
      "aws.leo60228.space" = {
        onlySSL = true;
        enableACME = true;
        acmeRoot = "/var/lib/acme/acme-challenge";
        # breaks websockets
        #http2 = true;
        locations = {
          "/" = {
            root = pkgs.runCommand "webroot" { } ''
              mkdir -p $out
              echo "This is an aggregator of my private web services. It doesn't have an actual website." > $out/index.html
            '';
            extraConfig = ''
              etag off;
            '';
          };
        };
      };
      "60228.dev" = {
        root = "${pkgs.leoPkgs.crabstodon}/public/";
        #root = "/home/leo60228/mastodon-src-current/public";
        forceSSL = true;
        enableACME = true;

        locations."/system/".alias = "/var/lib/mastodon/public-system/";

        locations."/" = {
          tryFiles = "$uri @proxy";
        };

        locations."@proxy" = {
          proxyPass = "http://127.0.0.1:55001";
          proxyWebsockets = true;
        };

        locations."/api/v1/streaming/" = {
          proxyPass = "http://unix:/run/mastodon-streaming/streaming-1.socket";
          proxyWebsockets = true;
        };

        locations."~* ^(\\/_matrix|\\/_synapse\\/client)" = {
          proxyPass = "http://localhost:8008";
          extraConfig = ''
            proxy_set_header X-Forwarded-For $remote_addr;
            client_max_body_size 50M;
          '';
        };

        locations."=/.well-known/matrix/server" = {
          alias = pkgs.writeText "matrix-delegation" (builtins.toJSON { "m.server" = "60228.dev:443"; });
        };
      };
      "l.60228.dev" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyWebsockets = true;
          extraConfig = ''
            set $proxpass "http://0.0.0.0:1234";
            if ($http_accept ~ "^application/.*$") {
              set $proxpass "http://0.0.0.0:8536";
            }
            if ($request_method = POST) {
              set $proxpass "http://0.0.0.0:8536";
            }
            proxy_pass $proxpass;

            rewrite ^(.+)/+$ $1 permanent;

            # Send actual client IP upstream
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };

        locations."~ ^/(api|pictrs|feeds|nodeinfo|.well-known)" = {
          proxyPass = "http://0.0.0.0:8536";
          proxyWebsockets = true;
          extraConfig = ''
            # Add IP forwarding headers
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          '';
        };

        locations."~ /pictshare/([\s]*)$" = {
          extraConfig = ''
            return 301 /pictrs/image/$1;
          '';
        };
      };
      "*.pds.vriska.dev" = {
        forceSSL = true;
        useACMEHost = "pds.vriska.dev";
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://localhost:3000";
        };
      };
      "pds.vriska.dev" = {
        forceSSL = true;
        useACMEHost = "pds.vriska.dev";
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://localhost:3000";
        };
      };
      "localhost" = {
        default = true;
        locations = {
          "/" = {
            extraConfig = "return 301 https://aws.leo60228.space$request_uri;";
          };
          "=/http/pack.zip" = {
            alias = ../../files/pack.zip;
            extraConfig = ''
              etag off;
            '';
          };
        };
      };
    };
  };
}
