{
  nixos = { pkgs, lib, modulesPath, ... }: {
    imports = [ "${modulesPath}/installer/sd-card/sd-image-aarch64-installer.nix" ];
    boot.kernelPackages = pkgs.linuxPackages_rpi4;
    boot.initrd.availableKernelModules = [ "usbhid" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    swapDevices = [ ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

    networking.wireless.enable = false;
    networking.hostName = "nixpi";

    boot.loader = {
      generic-extlinux-compatible.enable = lib.mkForce false;
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
