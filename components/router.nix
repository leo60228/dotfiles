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
        externalInterface = "enp1s0u1";
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
      interfaces.enp1s0u1.useDHCP = true;
      firewall = {
        trustedInterfaces = [ "eth0" ];
      };
      dhcpcd = {
        allowInterfaces = [ "enp1s0u1" ];
        wait = "ipv4";
        extraConfig = ''
        duid
        persistent

        interface enp1s0u1
          ia_na 1
          ia_pd 2/::/56 eth0/0/56/1
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
        #enable = true;
        config = "";
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
      dhclient -6 -P --prefix-len-hint 56 -d enp1s0u1 -e PATH="$PATH" -lf /var/lib/dhclient/leases -sf ${pkgs.dhcp}/sbin/dhclient-script
      '';
    };

    environment.etc."dhclient-exit-hooks".source = pkgs.substituteAll {
      src = ../files/dhclient-exit-hooks;
      binPath = with pkgs; lib.makeBinPath [ dhcp systemd utillinux iproute gnugrep ];
      inherit (pkgs) bash;
    };
  };
})
