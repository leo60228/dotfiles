let lib = import ../lib; in
lib.makeComponent "hass"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    services.home-assistant = {
      enable = true;
    };
  };
})
