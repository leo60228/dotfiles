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
        "ahci"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ "dm-snapshot" ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/d3eb82e7-ce0f-4dd3-827e-d66a509e57ef";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/2AB3-7B0A";
        fsType = "vfat";
      };

      swapDevices = [ { device = "/dev/disk/by-uuid/6dd87cfe-e02e-4a6a-bd48-e0a0ca770d01"; } ];

      nix.settings.max-jobs = lib.mkDefault 12;
      powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

      deployment.tags = [ "servers" ];
    };

  nixops = { };

  system = "x86_64-linux";
}
