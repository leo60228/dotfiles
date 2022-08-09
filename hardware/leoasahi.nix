{
  nixos = { config, lib, modulesPath, flakes, pkgs, ... }:
  {
    imports =
      [ "${modulesPath}/installer/scan/not-detected.nix"
        "${flakes.nixos-m1}/nix/m1-support/default.nix"
      ];

    boot.initrd.availableKernelModules = [ "usb_storage" ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/ef8a4547-4f94-419d-8cc4-a064c55a9932";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/BEA9-1AE7";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/3230ae34-12ce-493b-b632-8cf89db84214"; }
      ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
    powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  nixops = {
    deployment.targetHost = "leoasahi";
  };

  system = "aarch64-linux";
}
