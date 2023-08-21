let lib = import ../lib; in
lib.makeComponent "apcupsd-server"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    services.apcupsd = {
      enable = true;
      configText = ''
      UPSCABLE usb
      UPSTYPE usb
      DEVICE
      UPSCLASS standalone
      UPSMODE disable
      NETSERVER on
      '';
    };
    networking.firewall.allowedTCPPorts = [ 3551 ];
  };
})
