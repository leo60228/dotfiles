{
  pkgs,
  lib,
  flakes,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
