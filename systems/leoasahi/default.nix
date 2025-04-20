{ config, pkgs, ... }:

with import ../../components;
{
  imports = [ ./hardware.nix ];

  system.stateVersion = "18.03";
}
