{
  nixos = { config, lib, modulesPath, pkgs, ... }: {
    imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];

    fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };
    fileSystems."/boot/efi" = { device = "/dev/disk/by-uuid/A44D-C446"; fsType = "vfat"; };

    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };

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
