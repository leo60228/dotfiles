let lib = import ../lib; in
lib.makeComponent "reverseproxy"
({cfg, config, pkgs, lib, ...}: with lib; {
  opts = {
    host = mkOption {
      type = types.nullOr types.string;
      default = null;
    };
  };

  config = {
    security.acme.email = "leo@60228.dev";
    security.acme.acceptTerms = true;

    services.phpfpm = lib.mkIf (cfg.host == "aws") (lib.mkForce {
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
    });

    services.nginx = lib.mkMerge [
      #(if cfg.host != "aws" then throw "Invalid nginx host" else {})
      (lib.mkIf (cfg.host == "aws") (lib.mkForce {
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
            serverAliases = [ "net-ref.com.leo60228.space" ];
            # breaks websockets
            #http2 = true;
            locations = let mkFilter = loc: port: sec: {
              "/${loc}/" = {
                proxyWebsockets = true;
                proxyPass = if builtins.isString port then port else "http://localhost:${toString port}/";
                extraConfig = ''
                sub_filter '${if !builtins.isString port then ":" else ""}${toString port}' '/${loc}';
                sub_filter 's.jezevec10.com' 'aws.leo60228.space/jstrisassets';
                sub_filter 'localhost/codeserver:80/' 'aws.leo60228.space/codeserver/';
                sub_filter 'src="/lang/' 'src="/jstris/lang/';
                sub_filter '__webpack_hmr' 'testing/__webpack_hmr';
                sub_filter_types *;
                sub_filter_once off;
                proxy_ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
                proxy_ssl_ciphers HIGH:!aNULL:!MD5;
                proxy_ssl_server_name on;
                add_header 'Access-Control-Allow-Origin' '*';
                add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
                add_header 'Access-Control-Allow-Headers' 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range';
                add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range';
                '' + (if sec then ''
                auth_basic "Secured";
                auth_basic_user_file /var/keys/htpasswd;
                '' else "") + (if builtins.isString port then ''
                proxy_set_header Host $proxy_host;
                '' else ''
                proxy_set_header Host aws.leo60228.space:443;
                proxy_ssl_verify off;
                proxy_set_header X-Forwarded-Proto $scheme;
                '');
              };
            }; in builtins.foldl' /*' yay for syntax bugs */ (a: b: a // b) {} [
              (let orig = mkFilter "icecast" 14501 true; in orig // {
                "/icecast/" = orig."/icecast/" // {
                  extraConfig = orig."/icecast/".extraConfig + ''
                  proxy_set_header Authorization "Basic YWRtaW46cGFzc3dvcmQ=";
                  '';
                };
              })
              (mkFilter "testing" 8080 true)
              (mkFilter "desktopxpra" "http://192.168.1.131:14500/" true)
              (mkFilter "pubtesting" 8081 true)
              (mkFilter "ahorn" 8103 true)
              (mkFilter "codeserver" 8443 true)
              (mkFilter "shell" 8022 false)
              (mkFilter "xpra" 14500 true)
              (mkFilter "testing2" 8000 true)
              (mkFilter "everestapi" "https://everestapi.github.io/" false)
              (mkFilter "gba" "https://jsemu2.github.io" false)
              (mkFilter "cookieclicker" "https://orteil.dashnet.org" false) # lack of final slash intentional
              (mkFilter "jstris" "https://jstris.jezevec10.com/" false)
              (mkFilter "jstrisassets" "https://s.jezevec10.com/" false)
              {
                "/" = {
                  root = pkgs.runCommand "webroot" {} ''
                  mkdir -p $out
                  echo "This is an aggregator of my private web services. It doesn't have an actual website." > $out/index.html
                  '';
                  extraConfig = ''
                  etag off;
                  '';
                };
                "/miniproxy" = {
                  root = pkgs.runCommand "proxyroot" {} ''
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
              }
            ];
          };
          "elixire.leo60228.space" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = "/var/lib/acme/acme-challenge";
            locations."/" = {
                proxyPass = "http://127.0.0.1:3002";
                proxyWebsockets = true;
                extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto https;
                proxy_set_header Proxy "";
                proxy_pass_header Server;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                '';
            };
          };
          "mastodon.leo60228.space" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = "/var/lib/acme/acme-challenge";
            root = "/home/leo60228/mastodon/public/";
            locations."/" = {
                tryFiles = "$uri @proxy";
            };
            locations."@proxy" = {
                proxyPass = "http://127.0.0.1:3000";
                proxyWebsockets = true;
                extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto https;
                proxy_set_header Proxy "";
                proxy_pass_header Server;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                '';
            };
            locations."/api/v1/streaming/" = {
                proxyPass = "http://127.0.0.1:4000";
                proxyWebsockets = true;
                extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto https;
                proxy_set_header Proxy "";
                proxy_pass_header Server;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                '';
            };
          };
          "blog.leo60228.space" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = "/var/lib/acme/acme-challenge";
            locations."~ ^/(css|img|js|fonts)/" = {
                root = "/home/leo60228/writefreely/static/";
            };
            locations."/" = {
                proxyPass = "http://127.0.0.1:3001";
                proxyWebsockets = true;
                extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto https;
                proxy_set_header Proxy "";
                proxy_pass_header Server;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                '';
            };
          };
          "ghastly.leo60228.space" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = "/var/lib/acme/acme-challenge";
            locations."/" = {
                proxyPass = "http://leo60228.github.io";
                proxyWebsockets = true;
                extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto https;
                proxy_set_header Proxy "";
                proxy_pass_header Server;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                '';
            };
          };
          "levelbot.leo60228.space" = {
            forceSSL = true;
            enableACME = true;
            acmeRoot = "/var/lib/acme/acme-challenge";
            locations."/" = {
                proxyPass = "http://192.168.1.146:3000";
                proxyWebsockets = true;
                extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Forwarded-Proto https;
                proxy_set_header Proxy "";
                proxy_pass_header Server;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;
                '';
            };
          };
          "net-ref.com.leo6028.space" = {
            locations = {
              "/" = {
                extraConfig = "return 301 https://net-ref.com.leo60228.space$request_uri;";
              };
              "=/http/pack.zip" = {
                alias = ../files/pack.zip;
                extraConfig = ''
                etag off;
                '';
              };
            };
          };
          "60228.dev" = {
            root = "${pkgs.mastodon}/public/";
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
              proxyPass = "http://127.0.0.1:55000/";
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
              alias = pkgs.writeText "matrix-delegation" (builtins.toJSON {
                "m.server" = "60228.dev:443";
              });
            };
          };
          "tcgplayer.leo60228.space" = {
            forceSSL = true;
            enableACME = true;

            locations."/" = {
              extraConfig = ''
              proxy_set_header User-Agent "leo's scripts";
              proxy_pass https://api.tcgplayer.com;
              '';
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
      }))
    ];
  };
})
