let
  lib = import ../lib;
in
lib.makeComponent "tailscale" (
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
      environment.systemPackages = [ pkgs.tailscale ];
      services.tailscale.enable = true;
      networking.firewall.trustedInterfaces = [ "tailscale0" ]; # tailscale has its own firewall, and default-deny on tailscale0 causes breakage
      networking.firewall.checkReversePath = "loose";
    };
  }
)
