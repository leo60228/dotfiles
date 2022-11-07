{
  nixos = { config, lib, modulesPath, pkgs, ... }: {
    imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

    fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
    fileSystems."/boot" = { device = "/dev/disk/by-uuid/A44D-C446"; fsType = "vfat"; };

    zramSwap.enable = true;

    swapDevices = [ {
      device = "/var/swapfile";
      size = 4096;
    } ];
  };

  nixops = {
    deployment.targetHost = "crabstodon";
  };

  system = "aarch64-linux";
}
