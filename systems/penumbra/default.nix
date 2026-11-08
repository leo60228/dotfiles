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
        startUid = 100000;
        count = 65536 * 2;
      }
    ];
    subGidRanges = [
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
          type = "snap";
          name = "snapshot";

          filesystems."rpool/root<" = true;

          snapshotting = {
            type = "periodic";
            interval = "15m";
            prefix = "zrepl_";
          };

          pruning.keep = [
            {
              type = "grid";
              grid = "1x1h(keep=all) | 24x1h | 2x1d";
              regex = "^zrepl_.*";
            }
            {
              type = "regex";
              negate = true;
              regex = "^zrepl_.*";
            }
          ];
        }
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
            keep_sender = [
              {
                type = "regex";
                regex = ".*";
              }
            ];
            keep_receiver = [
              {
                type = "regex";
                negate = true;
                regex = "^zrepl_.*$";
              }
              {
                type = "grid";
                grid = "1x1h(keep=all) | 24x1h | 360x1d";
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
