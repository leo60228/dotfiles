{
  pkgs,
  ...
}:
{
  security.acme = {
    defaults.email = "leo@60228.dev";
    acceptTerms = true;
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "50m";
    commonHttpConfig = ''
      ssl_ecdh_curve X25519MLKEM768:X25519:prime256v1:secp521r1:secp384r1;
      log_format full '$remote_addr - $remote_user [$time_local] '
                      '"$request" $status $bytes_sent '
                      '"$http_referer" "$http_user_agent"';
    '';
    virtualHosts = {
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
        locations."=/chordiwiki-icon.png".alias = ../../files/chordiwiki-icon.png;
        locations."=/chordiwiki-1x.png".alias = ../../files/chordiwiki-1x.png;
        locations."=/chordiwiki-1.5x.png".alias = ../../files/chordiwiki-1.5x.png;
        locations."=/chordiwiki-2x.png".alias = ../../files/chordiwiki-2x.png;
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
  };
}
