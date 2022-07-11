{
  nixos = { lib, pkgs, modulesPath, ... }: {
    imports =
      [ (modulesPath + "/installer/scan/not-detected.nix")
      ];

    boot.initrd.availableKernelModules = [ "usb_storage" "usbhid" ];
    boot.initrd.kernelModules = [ "sun4i-drm" "sun4i-drm-hdmi" "sun8i-drm-hdmi" ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];
    boot.kernelPackages = pkgs.linuxPackages_5_18;
    boot.kernelParams = [ "cma=64M" ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/9a6a4550-7114-4f43-8e1f-9c4d0727ff4a";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/894C-93FC";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/6e379a0b-382e-4ca4-b1d7-739105c4f466"; }
      ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  nixops.deployment.targetHost = "leopine";

  system = "aarch64-linux";
}
