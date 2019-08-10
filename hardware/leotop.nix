{
    nixos = { config, lib, pkgs, ... }:
    {
        imports =
            [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
            ];

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];
        boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffff7fff" ];

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

        systemd.services.gpu-fixup = {
            description = "GPU performance fixer";
            wantedBy = [ "multi-user.target" ];
            serviceConfig.Type = "oneshot";
            script = "${../files/gpu-fixup.sh}";
        };

        systemd.services.perf-checkup = {
            description = "Performance monitor";
            wantedBy = [ "multi-user.target" ];
            after = [ "display-manager.service" ];
            serviceConfig.User = "leo60228";
            script = "DISPLAY=:0 /home/leo60228/.cargo/bin/perf-checkup";
        };

        services.xserver.videoDrivers =  [ "amdgpu" ];
        services.xserver.deviceSection = ''
        Option "DRI" "3"
        Option "VariableRefresh" "true"
        '';
        services.xserver.exportConfiguration = true;
        nixpkgs.overlays = [ (import ../nixpkgs/xorg.nix) ];
    };

    nixops = {
        deployment.targetHost = "leotop2.local";
    };
}
