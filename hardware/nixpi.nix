{
  nixos = { pkgs, lib, modulesPath, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_rpi4;
    boot.initrd.availableKernelModules = lib.mkForce [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    boot.loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 4;
      };
    };

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/164e757f-b778-47f8-8444-7a963df3aecb";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/2178-694E";
        fsType = "vfat";
      };

    swapDevices = [ ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

    networking.wireless.enable = false;
    networking.hostName = "nixpi";
  };

  nixops.deployment.targetHost = "10.4.13.1";

  system = "aarch64-linux";
}
