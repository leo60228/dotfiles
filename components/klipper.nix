let
  lib = import ../lib;
in
lib.makeComponent "klipper" (
  {
    cfg,
    pkgs,
    lib,
    ...
  }:
  with lib;
  {
    opts = { };

    config = {
      services.klipper = {
        enable = true;
        user = "moonraker";
        group = "moonraker";
      };

      environment.etc."klipper.cfg".enable = false; # don't tie nixos config to printer hardware

      services.moonraker = {
        enable = true;
        settings = {
          data_store = {
            temperature_store_size = 600;
            gcode_store_size = 1000;
          };
          authorization = {
            force_logins = true;
            cors_domains = [ "*://app.fluidd.xyz" ];
            trusted_clients = [
              "100.64.0.0/10"
              "fd7a:115c:a1e0:ab12::/64"
            ];
          };
          history = { };
          octoprint_compat = { };
        };
      };

      services.fluidd = {
        enable = true;
        hostName = "leopine";
        nginx.serverAliases = [
          "10.4.13.187"
          "leopine.leo60228.github.beta.tailscale.net"
        ];
      };

      services.nginx.recommendedProxySettings = true;
    };
  }
)
