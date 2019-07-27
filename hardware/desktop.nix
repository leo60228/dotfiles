{
  nixos = { config, lib, pkgs, ... }:
  {
    imports =
      [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ];

    environment.systemPackages = with pkgs; [ vulkan-loader vulkan-tools ];

    systemd.package = pkgs.callPackage ../systemd-zen2.nix {};

    boot.kernelPackages = (import /home/leo60228/nixpkgs {}).linuxPackages_testing;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    hardware.firmware = [ (import /home/leo60228/nixpkgs {}).navifw ];

    hardware.opengl.package = pkgs.buildEnv {
        name = "navi-opengl";
        paths = let mesa = (import /home/leo60228/nixpkgs {}).mesa; in [ mesa mesa.drivers ];
    };

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/b1301acc-d5bf-4a8d-9738-c2aaf36660a2";
        fsType = "ext4";
      };

    fileSystems."/home" =
      { device = "/dev/disk/by-uuid/f5335260-cd87-4906-8f1f-2875f2462a5c";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/03F6-A8D5";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/2804b7e0-0256-431b-8ea8-31817a48d05a"; }
      ];

    nix.maxJobs = lib.mkDefault 4;
    powerManagement.cpuFreqGovernor = "performance";

    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.enableRedistributableFirmware = true;
    hardware.cpu.amd.updateMicrocode = true;
  };

  nixops = {
    deployment.targetHost = "192.168.1.131";
  };
}
