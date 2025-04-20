{
  config,
  lib,
  pkgs,
  flakes,
  ...
}:
{
  imports = [
    (import "${flakes.mobile-nixos}/lib/configuration.nix" { device = "lenovo-krane"; })
  ];

  networking.firewall.checkReversePath = lib.mkForce false;
}
