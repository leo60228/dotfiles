let lib = import ../lib; in
lib.makeComponent "tailscale"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    environment.systemPackages = [ pkgs.tailscale ];
    services.tailscale.enable = true;
  };
})
