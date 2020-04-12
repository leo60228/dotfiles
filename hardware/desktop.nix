{
  nixos = { config, lib, pkgs, ... }:
  let mesaPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/48a137da7301f3ec5e15f8c32945b64581ef9f70.tar.gz";
    sha256 = "17mrn7y7s2vi6crk6xkcq0hsz56a32y4c2qxxbdxnb7bpy9738gn";
  }) {};
      mesa = mesaPkgs.mesa;
      kernelPkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/4fbd9e3ab8b9ff17108371b71db20644747536c6.tar.gz";
        sha256 = "1s51ps9psds19abjh09dsrlrg9qadgyc7k25b9krj4fkfqb3fr9p";
      }) {};
  in {
    imports =
      [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ];

    environment.systemPackages = with pkgs; [ vulkan-loader vulkan-tools ];

    boot.kernelPackages = kernelPkgs.linuxPackages_latest;
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
        paths = [ mesa mesa.drivers ];
    };

    hardware.opengl.package32 = with pkgs; pkgsi686Linux.buildEnv {
        name = "navi-opengl32";
        paths = with mesaPkgs.pkgsi686Linux; [ mesa mesa.drivers ];
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
      [ { device = "/dev/disk/by-partlabel/HIBERNATE"; }
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

    systemd.sleep.extraConfig = "HibernateMode=reboot";
    security.wrappers.windows.source = pkgs.writeShellScript "windows" ''
    set -e
    whoami
    if [[ "$(id -u)" != "0" ]]; then exec sudo -- "$0" "$@"; fi
    ${pkgs.efibootmgr}/bin/efibootmgr --bootnext 0003
    ${pkgs.systemd}/bin/systemctl hibernate
    '';
  };

  nixops = {
    deployment.targetHost = "192.168.1.131";
  };
}
