{
  nixos = { config, lib, pkgs, ... }:
  {
    imports =
      [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ];

    environment.systemPackages = with pkgs; [ vulkan-loader vulkan-tools ];

    boot.kernelPackages = with pkgs; let
        baseKernel = linux_5_5;
        kernel = baseKernel.override {
            kernelPatches = [ {
                name = "navi10-vfio-reset";
                patch = fetchurl {
                    url = https://gitlab.manjaro.org/packages/core/linux55/-/raw/c93d32d693c7c34da9b30ce81c056588b19ececc/0001-nonupstream-navi10-vfio-reset.patch;
                    sha256 = "1708sf86hv8yn5w0h94fckrmpdarl2z2vph1307rycyidpw5h9vs";
                };
            } ];
        };
        kernelPackages = recurseIntoAttrs (linuxPackagesFor kernel);
        in kernelPackages;
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];
    boot.kernelParams = [
        "amdgpu.ppfeaturemask=0xffff7fff" # overclocking
        "idle=nomwait" # possible workaround to hangs
        "video=efifb:off"
    ];

    hardware.opengl.package = pkgs.buildEnv {
        name = "navi-opengl";
        paths = let mesa = pkgs.callPackage ../mesa {
            llvmPackages = pkgs.llvmPackages_9;
            inherit (pkgs.darwin.apple_sdk.frameworks) OpenGL;
            inherit (pkgs.darwin.apple_sdk.libs) Xplugin;
        }; in [ mesa mesa.drivers ];
    };

    hardware.opengl.package32 = with pkgs; pkgsi686Linux.buildEnv {
        name = "navi-opengl32";
        paths = let mesa = pkgsi686Linux.callPackage ../mesa {
            llvmPackages = pkgsi686Linux.llvmPackages_9;
            inherit (pkgsi686Linux.darwin.apple_sdk.frameworks) OpenGL;
            inherit (pkgsi686Linux.darwin.apple_sdk.libs) Xplugin;
        }; in [ mesa mesa.drivers ];
    };

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/b1301acc-d5bf-4a8d-9738-c2aaf36660a2";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/3556-7F76";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/2804b7e0-0256-431b-8ea8-31817a48d05a"; }
      ];

    nix.maxJobs = lib.mkDefault 12;
    powerManagement.cpuFreqGovernor = "performance";

    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.enableRedistributableFirmware = true;
    hardware.cpu.amd.updateMicrocode = true;

    systemd.services.gpu-fixup = {
        description = "GPU performance fixer";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        script = ''
            echo manual > /sys/class/drm/card0/device/power_dpm_force_performance_level
        '';
    };

    systemd.services.fanctl = {
        description = "GPU fan controller";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Restart = "always";
        script = "${../files/fanctl} -c ${../files/fanctl.yml}";
    };

    # hidpi
    services.xserver.displayManager.xserverArgs = [ "-dpi 185" ];
    console.earlySetup = true;
    console.packages = [ pkgs.terminus_font ];
    console.font = "ter-128n";
    services.xserver.deviceSection = ''
    Option "DRI" "3"
    Option "VariableRefresh" "true"
    '';
    services.xserver.exportConfiguration = true;

    hardware.pulseaudio.extraConfig = ''
    load-module module-remap-sink sink_name=reverse-stereo master=alsa_output.pci-0000_0c_00.4.analog-stereo channels=2 master_channel_map=front-right,front-left channel_map=front-left,front-right
    set-default-sink reverse-stereo
    '';
  };

  nixops = {
    deployment.targetHost = "192.168.1.131";
  };
}
