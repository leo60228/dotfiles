{
  nixos =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      flakes,
      ...
    }:
    {
      imports = [
        "${modulesPath}/installer/scan/not-detected.nix"
        flakes.nixos-hardware.nixosModules.framework-13-7040-amd
      ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ "dm-snapshot" ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/41691e95-8ec6-45a9-8f0e-6a3c72fd6c70";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/5EBE-7AB7";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/f735a083-e7e4-46ca-a0b0-73f280f3d8ad"; }
      ];

      boot.initrd.luks.devices."lvm".device = "/dev/disk/by-uuid/32bfc36e-2640-4110-bc58-b93564acaafa";

      services.power-profiles-daemon.enable = true;

      deployment.tags = [ "workstation" ];
      deployment.allowLocalDeployment = true;
    };

  nixops = {
    deployment.targetHost = "penumbra";
  };

  system = "x86_64-linux";
}
