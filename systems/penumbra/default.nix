# vi: set foldmethod=marker:

{
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "18.03";

  vris.workstation = true;
  vris.graphical = true;
  vris.mobile = true;

  hardware.bluetooth.enable = true;

  networking.firewall.allowedTCPPorts = lib.range 3000 3010;
  networking.firewall.allowedUDPPorts = lib.range 3000 3010;

  # LXC {{{1
  users.extraUsers.leo60228 = {
    extraGroups = [
      "lxc-user"
    ];
    createHome = false;
    autoSubUidGidRange = lib.mkForce false;
    subUidRanges = [
      {
        startUid = 1000;
        count = 1;
      }
      {
        startUid = 100000;
        count = 65536 * 2;
      }
    ];
    subGidRanges = [
      {
        startGid = 100;
        count = 1;
      }
      {
        startGid = 100000;
        count = 65536 * 2;
      }
    ];
  };

  virtualisation.lxc = {
    enable = true;
    unprivilegedContainers = true;
    usernetConfig = ''
      leo60228 veth lxcbr0 10
    '';
  };

  # Waydroid {{{1
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid.overrideAttrs (oldAttrs: {
      preFixup = ''
        sed -i~ -E 's/=.\$\(command -v (nft|ip6?tables-legacy).*/=/g' $out/lib/waydroid/data/scripts/waydroid-net.sh
        ${oldAttrs.preFixup}
      '';
    });
  };

  # zrepl {{{1
  services.zrepl = {
    enable = true;
    settings = {
      jobs = [
        {
          type = "push";
          name = "push_to_workstation";

          connect = {
            type = "tcp";
            address = "100.70.195.127:8888";
          };

          filesystems."rpool/root<" = true;

          send.encrypted = true;
          replication = {
            protection = {
              initial = "guarantee_resumability";
              incremental = "guarantee_incremental";
            };
          };

          snapshotting.type = "manual";
          pruning = {
            keep_sender = [ { type = "not_replicated"; } ];
            keep_receiver = [
              {
                type = "regex";
                negate = true;
                regex = "^zrepl_.*$";
              }
              {
                type = "last_n";
                count = 2;
                regex = "^zrepl_.*$";
              }
            ];
          };
        }
      ];
    };
  };
  # }}}
}
