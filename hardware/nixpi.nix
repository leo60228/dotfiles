{
  nixos = { pkgs, lib, modulesPath, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_rpi4;
    boot.initrd.availableKernelModules = [ "usbhid" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
        fsType = "ext4";
      };

    swapDevices = [ ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

    networking.wireless.enable = false;
    networking.hostName = "nixpi";

    boot.loader = {
      grub.enable = false;
      raspberryPi = {
        enable = true;
        version = 4;
        firmwareConfig = ''
        over_voltage=6
        arm_freq=2147
        '';
      };
    };
  };

  nixops.deployment.targetHost = "10.4.13.1";

  system = "aarch64-linux";
}
