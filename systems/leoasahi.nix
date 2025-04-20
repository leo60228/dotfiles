{ config, pkgs, ... }:

with import ../components;
{
  components = home { small = true; };

  system.stateVersion = "18.03";
}
