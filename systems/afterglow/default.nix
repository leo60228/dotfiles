{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "25.05";

  vris.graphical = true;
}
