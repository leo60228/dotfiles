{
  nixos =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      ...
    }:
    {
      imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "aesni_intel"
        "cryptd"
      ];
      boot.initrd.kernelModules = [ "dm-snapshot" ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.kernelPackages = pkgs.linuxPackages_latest;

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/b1a22376-6513-4815-b98d-9a1b6a6069a4";
        fsType = "btrfs";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/4210-B02C";
        fsType = "vfat";
      };

      swapDevices = [ { device = "/dev/disk/by-uuid/2ebfa1d0-e726-4227-9365-53b66e7d5a21"; } ];

      boot.initrd.luks.devices."encrypted".device = "/dev/disk/by-uuid/26c8fcc6-0823-472d-afdb-61d823af227c";

      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      services.power-profiles-daemon.enable = true;

      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia.open = true;
      hardware.nvidia.modesetting.enable = true;
      hardware.nvidia.prime = {
        offload.enable = true;
        amdgpuBusId = "PCI:4:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      boot.kernelParams = [ "nvidia.NVreg_EnableS0ixPowerManagement=1" ];

      deployment.tags = [ "workstation" ];
      deployment.allowLocalDeployment = true;
    };

  nixops = {
    deployment.targetHost = "zephyrus.local";
  };

  system = "x86_64-linux";
}
