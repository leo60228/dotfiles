{
    nixos = { config, lib, modulesPath, pkgs, ... }:
    {
        imports =
            [ "${modulesPath}/installer/scan/not-detected.nix"
            ];

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffff7fff" ];

        #boot.kernelPackages = (import <unstable> {}).linuxPackages_latest;

        hardware.enableAllFirmware = true;

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

        nix.maxJobs = lib.mkDefault 8;
        powerManagement.cpuFreqGovernor = "ondemand";

        systemd.services.gpu-fixup = {
            description = "GPU performance fixer";
            wantedBy = [ "multi-user.target" ];
            serviceConfig.Type = "oneshot";
            script = "${../files/gpu-fixup.sh}";
            serviceConfig.User = "root";
        };

        #systemd.services.perf-checkup = {
        #    description = "Performance monitor";
        #    wantedBy = [ "multi-user.target" ];
        #    after = [ "display-manager.service" ];
        #    serviceConfig.User = "leo60228";
        #    script = "DISPLAY=:0 /home/leo60228/.cargo/bin/perf-checkup";
        #};

        services.xserver.videoDrivers =  [ "amdgpu" ];
        services.xserver.deviceSection = ''
        Option "DRI" "3"
        Option "VariableRefresh" "true"
        '';
        #services.xserver.displayManager.xserverArgs = [ "-dpi 185" ];
        #services.xserver.exportConfiguration = true;
        #console.packages = [ pkgs.terminus_font ];
        #console.font = "ter-128n";

        hardware.bluetooth.settings.General.ControllerMode = "bredr";

        hardware.cpu.amd.updateMicrocode = true;

        hardware.firmware = [ (pkgs.runCommand "hda-jack-retask-fw" {} ''
        mkdir -p $out/lib/firmware
        cp ${../files/hda-jack-retask.fw} $out/lib/firmware/hda-jack-retask.fw
        '') ];

        boot.extraModprobeConfig = ''
        options snd-hda-intel patch=hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw power_save=0
        '';

        services.tlp = {
            enable = true;
            settings = {
                SOUND_POWER_SAVE_ON_AC = 1;
                SOUND_POWER_SAVE_ON_BAT = 0;
                SOUND_POWER_SAVE_CONTROLLER = "Y";
                RUNTIME_PM_ON_AC = "auto";
                WIFI_PWR_ON_AC = "on";
            };
        };

        hardware.pulseaudio.daemon.config = {
            remixing-produce-lfe = true;
            lfe-crossover-freq = 80;
        };
    };

    nixops = {
        deployment.targetHost = "leotop2.local";
    };

    system = "x86_64-linux";
}
