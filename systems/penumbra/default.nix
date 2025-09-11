# vi: set foldmethod=marker:

{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [ ./hardware.nix ];

  system.stateVersion = "18.03";

  vris.workstation = true;
  vris.graphical = true;

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

  # fwupd {{{1
  services.fwupd.enable = true;
  services.packagekit.enable = true;
  services.packagekit.settings.Daemon.DefaultBackend = "test_succeed";
  environment.etc."fwupd/remotes.d/lvfs-testing.conf" = lib.mkForce {
    text = ''
      [fwupd Remote]
      Enabled=true
      Title=Linux Vendor Firmware Service (testing)
      MetadataURI=https://cdn.fwupd.org/downloads/firmware-testing.xml.gz
      ReportURI=https://fwupd.org/lvfs/firmware/report
      OrderBefore=lvfs,fwupd
      AutomaticReports=false
      ApprovalRequired=false
    '';
  };
  # }}}
}
