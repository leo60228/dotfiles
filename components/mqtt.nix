let lib = import ../lib; in
lib.makeComponent "mqtt"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    services.mosquitto = {
      enable = true;
      allowAnonymous = true;
      host = "0.0.0.0";
      users = {};
      aclExtraConf = ''
      topic readwrite #
      user DVES_USER
      topic readwrite #
      '';
    };
    networking.firewall.allowedTCPPorts = [ 1883 ];
  };
})
