{ lib, ... }:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "26.05";

  users.extraUsers.leo60228.extraGroups = [ "incus-admin" ];

  networking.nftables.enable = true;
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;

    netdevs = lib.genAttrs [ "vmbr0" "vmbr1" ] (Name: {
      netdevConfig = {
        inherit Name;
        Kind = "bridge";
      };
    });

    networks = {
      "10-lan" = {
        matchConfig.Name = [ "end0" ];
        networkConfig.Bridge = "vmbr0";
      };

      "10-lan-bridge" = {
        matchConfig.Name = [ "vmbr0" ];
        networkConfig = {
          IPv6AcceptRA = true;
          DHCP = "ipv4";
        };
        linkConfig.RequiredForOnline = "routable";
      };

      "10-wan" = {
        matchConfig.Name = [ "enu1" ];
        networkConfig.Bridge = "vmbr1";
        linkConfig.ActivationPolicy = "always-up";
      };

      "10-wan-bridge" = {
        matchConfig.Name = [ "vmbr1" ];
        linkConfig.ActivationPolicy = "always-up";
      };
    };
  };

  virtualisation.incus = {
    enable = true;
    preseed = {
      storage_pools = [
        {
          name = "data";
          driver = "zfs";
          config.source = "rpool/incus";
        }
      ];
    };
  };
}
