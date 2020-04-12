{
    nixos = { config, lib, pkgs, ... }:
    {
        imports =
            [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
            ];

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" ];
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
        { device = "/dev/leobook/root";
            fsType = "ext4";
        };

        fileSystems."/tmp" =
        { device = "tmpfs";
            fsType = "tmpfs";
        };

        fileSystems."/boot" =
        { device = "/dev/disk/by-label/EFI";
            fsType = "vfat";
        };

        swapDevices =
            [ { device = "/dev/disk/by-label/SWAP"; }
            ];

        nix.maxJobs = lib.mkDefault 2;
        powerManagement.cpuFreqGovernor = "ondemand";

        zramSwap = {
            enable = true;
            algorithm = "lzo-rle";
        };
    };

    nixops = {
        deployment.targetHost = "leotop2.local";
    };
}
