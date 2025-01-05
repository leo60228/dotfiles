let
  lib = import ../lib;
in
lib.makeComponent "reverseproxy" (
  {
    cfg,
    config,
    pkgs,
    lib,
    ...
  }:
  with lib;
  {
    opts = {
      host = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };

    config = {
      security.acme.defaults.email = "leo@60228.dev";
      security.acme.acceptTerms = true;
      services.phpfpm = lib.mkIf (cfg.host == "aws") (
        lib.mkForce {
          pools."php" = {
            user = "nginx";
            group = "nginx";
            phpPackage = pkgs.php;
            settings = {
              "pm" = "dynamic";
              "pm.max_children" = 32;
              "pm.max_requests" = 500;
              "pm.start_servers" = 2;
              "pm.min_spare_servers" = 2;
              "pm.max_spare_servers" = 5;
              "php_admin_value[error_log]" = "stderr";
              "php_admin_flag[log_errors]" = true;
              "catch_workers_output" = true;
            };
          };
        }
      );

      services.nginx = lib.mkMerge [
        #(if cfg.host != "aws" then throw "Invalid nginx host" else {})
        (lib.mkIf (cfg.host == "aws") (
          lib.mkForce {
            enable = true;
            recommendedTlsSettings = true;
            recommendedOptimisation = true;
            recommendedGzipSettings = true;
            recommendedProxySettings = true;
            commonHttpConfig = ''
              ssl_ecdh_curve X25519Kyber768Draft00:X25519:prime256v1:secp521r1:secp384r1;
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
                  "/miniproxy" = {
                    root = pkgs.runCommand "proxyroot" { } ''
                      mkdir -p $out
                      cp -v ${../files/miniproxy.php} $out/index.php
                    '';
                    extraConfig = ''
                      auth_basic "Secured";
                      auth_basic_user_file /var/keys/htpasswd;
                      include ${pkgs.nginx}/conf/fastcgi_params;
                      include ${pkgs.nginx}/conf/fastcgi.conf;
                      fastcgi_split_path_info ^(.+\.php)(/.+)$;
                      fastcgi_param SCRIPT_FILENAME ${../files/miniproxy.php};
                      fastcgi_pass unix:${config.services.phpfpm.pools.php.socket};
                      fastcgi_index index.php;
                    '';
                  };
                  "/http" = {
                    extraConfig = "return 301 http://$server_name$request_uri;";
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
                    alias = ../files/pack.zip;
                    extraConfig = ''
                      etag off;
                    '';
                  };
                };
              };
            };
          }
        ))
        (lib.mkIf (cfg.host == "digitaleo") ({
          enable = true;
          recommendedTlsSettings = true;
          recommendedOptimisation = true;
          recommendedGzipSettings = true;
          recommendedProxySettings = true;
          clientMaxBodySize = "50m";
          commonHttpConfig = ''
            ssl_ecdh_curve X25519Kyber768Draft00:X25519:prime256v1:secp521r1:secp384r1;
            log_format full '$remote_addr - $remote_user [$time_local] '
                            '"$request" $status $bytes_sent '
                            '"$http_referer" "$http_user_agent"';
          '';
          virtualHosts = {
            "idoleyes.leo60228.space" = {
              forceSSL = true;
              enableACME = true;
              locations."/" = {
                proxyPass = "http://10.100.0.3:4130";
                extraConfig = ''
                  proxy_http_version 1.1;
                '';
              };
            };
            "grafana.leo60228.space" = {
              forceSSL = true;
              enableACME = true;
              locations."/" = {
                proxyPass = "http://localhost:3000";
              };
            };
            "chordiwiki.l3.pm" = {
              forceSSL = true;
              enableACME = true;
              locations."=/chordiwiki-icon.png".alias = ../files/chordiwiki-icon.png;
              locations."=/chordiwiki-1x.png".alias = ../files/chordiwiki-1x.png;
              locations."=/chordiwiki-1.5x.png".alias = ../files/chordiwiki-1.5x.png;
              locations."=/chordiwiki-2x.png".alias = ../files/chordiwiki-2x.png;
            };
            "maven.vriska.dev" = {
              forceSSL = true;
              enableACME = true;
              locations."/" = {
                proxyPass = "http://localhost:8080";
                proxyWebsockets = true;
              };
            };
          };
        }))
      ];
    };
  }
)
