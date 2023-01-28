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
            locations = {
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
      (lib.mkIf (cfg.host == "digitaleo") (lib.mkForce {
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
        };
      }))
    ];
  };
})
