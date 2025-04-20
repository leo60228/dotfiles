{ config, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "18.03";
}
