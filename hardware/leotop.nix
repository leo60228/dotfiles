{
  nixos = { config, lib, pkgs, ... }:
  {
    imports =
      [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/54f28256-31de-4eb2-af7b-a8f1e2c1ea4e";
        fsType = "ext4";
      };

    fileSystems."/tmp" =
      { device = "tmpfs";
        fsType = "tmpfs";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/2442-0985";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/8f13296f-1aac-4728-acdc-38550d52929c"; }
      ];

    nix.maxJobs = lib.mkDefault 16;
    powerManagement.cpuFreqGovernor = "performance";
  };

  nixops = {
    deployment.targetHost = "leotop2.local";
  };
}
