{
  config,
  pkgs,
  lib,
  ...
}:

with import ../components;
{
  components = efi en_us est gui kde {
    bluetooth = true;
  } docker steam extra home { deviceScaleFactor = 2; } tailscale flatpak fwupd kdeconnect kvm;

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
}
