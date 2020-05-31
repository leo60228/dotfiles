{
    nixos = { config, lib, pkgs, ... }:
    {
        imports =
            [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
            ];

        boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" "dm-cache" ];
        boot.extraModulePackages = [ ];

        # keyboard driver
        boot.kernelPackages = pkgs.linuxPackages_latest.extend (lib.const (ksuper: {
            kernel = with import <nixpkgs/lib/kernel.nix> { inherit lib; version = ksuper.kernel.version; };
            ksuper.kernel.override {
                structuredExtraConfig = {
                    PINCTRL_CHERRYVIEW = yes;
                    SERIO_I8042        = yes;
                };
            };
        }));

        hardware.enableAllFirmware = true;

        fileSystems."/" =
        { device = "/dev/chromebook/root";
            fsType = "ext4";
        };

        fileSystems."/tmp" =
        { device = "tmpfs";
            fsType = "tmpfs";
        };

        fileSystems."/boot" =
        { device = "/dev/disk/by-label/CHR-EFI";
            fsType = "vfat";
        };

        #swapDevices =
        #    [ { device = "/dev/disk/by-label/CHR-SWAP"; }
        #    ];

        nix.maxJobs = lib.mkDefault 2;
        powerManagement.cpuFreqGovernor = "ondemand";

        zramSwap = {
            enable = true;
            algorithm = "lzo-rle";
        };
    };

    nixops = {};
}
