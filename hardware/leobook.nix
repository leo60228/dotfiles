{
    nixos = { config, lib, modulesPath, flakes, pkgs, ... }:
    {
        imports =
            [ "${modulesPath}/installer/scan/not-detected.nix"
            ];

        boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
        boot.initrd.kernelModules = [ "dm_cache" "dm_cache_smq" "dm_bio_prison" "dm_persistent_data" "dm_bufio" "dm_mod" "libcrc32c" ];
        boot.extraModulePackages = [ ];

        # keyboard driver
        boot.kernelPackages = pkgs.linuxPackages_latest.extend (lib.const (ksuper: {
            kernel = with import "${flake.nixpkgs}/lib/kernel.nix" { inherit lib; version = ksuper.kernel.version; };
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

        swapDevices =
            [ { device = "/dev/chromebook/swap"; }
            ];

        nix.settings.max-jobs = lib.mkDefault 2;
        powerManagement.cpuFreqGovernor = "ondemand";

        zramSwap = {
            enable = true;
            algorithm = "lzo-rle";
        };
    };

    nixops = {};

    system = "x86_64-linux";
}
