{
  config,
  pkgs,
  lib,
  ...
}:

with import ../components;
{
  components = steam extra home {
    deviceScaleFactor = 2;
  } tailscale;

  system.stateVersion = "18.03";

  vris.workstation = true;
  vris.graphical = true;

  hardware.bluetooth.enable = true;

  users.extraUsers.leo60228 = {
    extraGroups = [
      "wheel"
      "docker"
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

  networking.firewall.allowedTCPPorts = lib.range 3000 3010;
  networking.firewall.allowedUDPPorts = lib.range 3000 3010;

  virtualisation.waydroid.enable = true;

  virtualisation.lxc = {
    enable = true;
    unprivilegedContainers = true;
    usernetConfig = ''
      leo60228 veth lxcbr0 10
    '';
  };

  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ];
    preferStaticEmulators = true;
    addEmulatedSystemsToNixSandbox = false;
  };

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
}
