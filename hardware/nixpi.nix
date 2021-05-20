{
  nixos = { pkgs, lib, modulesPath, ... }: {
    imports = [ "${modulesPath}/installer/cd-dvd/sd-image-raspberrypi4.nix" ];
    boot.initrd.availableKernelModules = lib.mkForce [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];

    swapDevices = [ ];

    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

    networking.wireless.enable = false;
    networking.hostName = "nixpi";
  };

  nixops.deployment.targetHost = "10.4.13.1";

  system = "aarch64-linux";
}
