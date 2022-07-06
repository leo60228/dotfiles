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
      dhcpd6 = {
        #enable = true;
        interfaces = [ "eth0" ];
        configFile = "/run/dhcpd6.conf";
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
    #systemd.services.dhcpd6.wantedBy = lib.mkForce [];
    #systemd.services.radvd.wantedBy = lib.mkForce [];
    #systemd.services.radvd.serviceConfig.ExecStart = lib.mkForce "@${pkgs.radvd}/bin/radvd radvd -n -u radvd -C /run/radvd.conf";
    boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;

    systemd.services.dhclient = {
      wantedBy = [ "multi-user.target" "network-online.target" ];
      wants = [ "network.target" "systemd-udev-settle.target" ];
      before = [ "network-online.target" ];
      after = [ "systemd-udev-settle.target" ];

      stopIfChanged = false;

      path = with pkgs; [ dhcp ];

      restartTriggers = [ config.environment.etc."dhclient-exit-hooks".source ];

      script = ''
      mkdir -m 755 -p /var/lib/dhclient
      dhclient -6 -P --prefix-len-hint 56 -d enp1s0u2 -e PATH="$PATH" -lf /var/lib/dhclient/leases -sf ${pkgs.dhcp}/sbin/dhclient-script
      '';
    };

    environment.etc."dhclient-exit-hooks".source = pkgs.substituteAll {
      src = ../files/dhclient-exit-hooks;
      binPath = with pkgs; lib.makeBinPath [ dhcp systemd utillinux iproute gnugrep ];
      inherit (pkgs) bash;
    };
  };
})
