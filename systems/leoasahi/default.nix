{ config, pkgs, ... }:

with import ../../components;
{
  imports = [ ./hardware.nix ];

  components = home { small = true; };

  system.stateVersion = "18.03";
}
