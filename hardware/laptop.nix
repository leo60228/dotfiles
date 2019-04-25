{
  nixos = { config, lib, pkgs, ... }:
  {
    imports =
      [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ];

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];
    boot.kernelParams = [ "intel_idle.max_cstate=4" "i915.edp_vswing=2" ];

    fileSystems."/" =
    { device = "/dev/disk/by-uuid/67e33deb-3f7c-4de9-b3e4-023a961fb5e6";
      fsType = "ext4";
    };

    fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/FE84-ACB0";
      fsType = "vfat";
    };

    swapDevices = [ ];

    nix.maxJobs = lib.mkDefault 8;
    powerManagement.cpuFreqGovernor = "powersave";

    #services.xserver.videoDrivers = [ "nvidia" "ati" "cirrus" "intel" "vesa" "vmware" "modesetting" ];
    
    #environment.sessionVariables.DRI_PRIME = "1";
    #systemd.globalEnvironment.DRI_PRIME = "1";
  };

  nixops = {
    deployment.targetHost = "leotop.local";
  };
}
