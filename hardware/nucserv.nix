{
  nixos = { config, lib, pkgs, modulesPath, ... }:
  {
    imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
      ];
  
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];
  
    fileSystems."/" =
      { device = "/dev/disk/by-uuid/8ae7197c-66f0-4bc1-8ade-3eb9d229ee19";
        fsType = "ext4";
      };
  
    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/4C2A-A7D2";
        fsType = "vfat";
      };
  
    swapDevices =
      [ { device = "/dev/disk/by-uuid/3d8e3a57-a230-448b-a3dc-d384d46f25ba"; }
      ];
  
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
