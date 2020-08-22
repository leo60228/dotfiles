let lib = import ../lib; in
lib.makeComponent "router"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    networking = {
      nat = {
        enable = true;
        internalIPs = [ "10.4.13.0/24" ];
        internalInterfaces = ["internal0"];
        externalInterface = "external0";
      };
      useDHCP = false;
      interfaces.internal0 = {
        ipv4.addresses = [ {
          address = "10.4.13.1";
          prefixLength = 24;
        } ];
      };
      interfaces.external0.useDHCP = true;
      firewall = {
        trustedInterfaces = [ "internal0" ];
      };
    };
    services.dhcpd4 = {
      enable = true;
      interfaces = [ "internal0" ];
      extraConfig = ''
      option subnet-mask 255.255.255.0;
      option broadcast-address 10.4.13.255;
      option routers 10.4.13.1;
      option domain-name-servers 1.1.1.1, 1.0.0.1;
      option domain-name "leo60228-router.duckdns.org";
      subnet 10.4.13.0 netmask 255.255.255.0 {
        range 10.4.13.100 10.4.13.200;
      }
      '';
    };
  };
})
