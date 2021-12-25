{
    nixos = { config, lib, modulesPath, pkgs, ... }:
    {
        imports =
            [ "${modulesPath}/installer/scan/not-detected.nix"
            ];

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "aesni_intel" "cryptd" ];
        boot.initrd.kernelModules = [ "dm-snapshot" ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.kernelPackages = pkgs.linuxPackages_5_15;
        boot.extraModulePackages = [ ];

        fileSystems."/" =
        { device = "/dev/disk/by-uuid/0488d275-44c7-427d-ada9-7b9ff86fb918";
            fsType = "btrfs";
        };

        fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/A6ED-2C41";
            fsType = "vfat";
        };

        swapDevices =
            [ { device = "/dev/disk/by-uuid/c5bdf63b-95a3-42fd-8168-ef719035f50b"; }
            ];

        boot.initrd.luks.devices."encrypted".device = "/dev/disk/by-uuid/a799c51a-f91e-4bb9-b5bc-de915756e589";

        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.nvidia.modesetting.enable = true;
        hardware.nvidia.prime = {
            offload.enable = true;
            amdgpuBusId = "PCI:4:0:0";
            nvidiaBusId = "PCI:1:0:0";
        };

        # high-resolution display
        hardware.video.hidpi.enable = lib.mkDefault true;
        services.xserver.displayManager.xserverArgs = [ "-dpi 128" ];
        console.earlySetup = true;
        console.packages = [ pkgs.terminus_font ];
        console.font = "ter-v32n";
    };

    nixops = {
        deployment.targetHost = "zephyrus.local";
    };

    system = "x86_64-linux";
}
