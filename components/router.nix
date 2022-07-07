let lib = import ../lib; in
lib.makeComponent "router"
({cfg, config, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    networking = {
      nat = {
        enable = true;
        internalIPs = [ "10.4.13.0/24" ];
        internalInterfaces = ["eth0"];
        externalInterface = "enp1s0u2";
        forwardPorts = [
          {
            destination = "10.4.13.103:34567";
            proto = "tcp";
            sourcePort = 34567;
          }
          {
            destination = "10.4.13.103:34567";
            proto = "udp";
            sourcePort = 34567;
          }
          {
            destination = "10.4.13.155:25565";
            proto = "tcp";
            sourcePort = 25565;
          }
          {
            destination = "10.4.13.155:25565";
            proto = "udp";
            sourcePort = 25565;
          }
          {
            destination = "10.4.13.155:19132";
            proto = "tcp";
            sourcePort = 19132;
          }
          {
            destination = "10.4.13.155:19132";
            proto = "udp";
            sourcePort = 19132;
          }
        ];
      };
      useDHCP = false;
      interfaces.eth0 = {
        tempAddress = "disabled";
        ipv4.addresses = [ {
          address = "10.4.13.1";
          prefixLength = 24;
        } ];
        ipv4.routes = [ {
          address = "224.0.0.0";
          prefixLength = 4;
        } ];
      };
      interfaces.enp1s0u2.useDHCP = true;
      firewall = {
        trustedInterfaces = [ "eth0" ];
      };
      dhcpcd = {
        allowInterfaces = [ "enp1s0u2" ];
        wait = "both";
        extraConfig = ''
        duid
        persistent

        interface enp1s0u2
          ia_na 1
          ia_pd 2/::/64 eth0/0/64/1
        '';
      };
    };
    services = {
      dhcpd4 = {
        enable = true;
        interfaces = [ "eth0" ];
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
      radvd = {
        enable = true;
        config = ''
        interface eth0 {
          AdvSendAdvert on;
          prefix ::/64 {};
        };
        '';
      };
    };
    boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
  };
})
