let lib = import ../lib; in
lib.makeComponent "mqtt"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    services.mosquitto = {
      enable = true;
      listeners = [ {
        address = "10.4.13.1";
        settings.allow_anonymous = true;
        omitPasswordAuth = true;
        acl = [
          "topic readwrite #"
          "user DVES_USER"
          "topic readwrite #"
        ];
      } ];
    };
    networking.firewall.allowedTCPPorts = [ 1883 ];
  };
})
