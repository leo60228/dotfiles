let lib = import ../lib; in
lib.makeComponent "reverseproxy"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    host = mkOption {
      type = types.nullOr types.string;
      default = null;
    };
  };

  config = {
    services.nginx = lib.mkMerge [
      #(if cfg.host != "digitalocean" then throw "Invalid nginx host" else {})
      (lib.mkIf (cfg.host == "aws") (lib.mkForce {
        enable = true;
        recommendedTlsSettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        virtualHosts = {
          "digitalocean.leo60228.space" = {
            onlySSL = true;
            enableACME = true;
            acmeRoot = "/var/lib/acme/acme-challenge";
            # breaks websockets
            #http2 = true;
            locations = let mkFilter = loc: port: sec: {
              "/${loc}/" = {
                proxyWebsockets = true;
                proxyPass = if builtins.isString port then port else "http://localhost:${toString port}/";
                extraConfig = ''
                sub_filter '${if !builtins.isString port then ":" else ""}${toString port}' '/${loc}';
                sub_filter 's.jezevec10.com' 'digitalocean.leo60228.space/jstrisassets';
                sub_filter 'src="/lang/' 'src="/jstris/lang/';
                sub_filter_types *;
                sub_filter_once off;
                proxy_set_header Host $proxy_host;
                proxy_set_header Accept-Encoding "";
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
                '' else "");
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
              (mkFilter "ahorn" 8103 true)
              (mkFilter "codeserver" 8443 true)
              (mkFilter "shell" 8022 false)
              (mkFilter "xpra" 14500 true)
              (mkFilter "gitea" 3000 false)
              (mkFilter "everestapi" "https://everestapi.github.io/" false)
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
          "localhost" = {
            default = true;
            locations = {
              "/" = {
                extraConfig = "return 301 https://digitalocean.leo60228.space$request_uri;";
              };
              "/http/pack.zip" = {
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
