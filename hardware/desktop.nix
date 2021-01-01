{
  nixos = { config, lib, modulesPath, pkgs, ... }:
  {
    imports =
      [ "${modulesPath}/installer/scan/not-detected.nix"
      ];

    environment.systemPackages = with pkgs; [
      (callPackage ../joycond.nix {})
      vulkan-loader
      vulkan-tools
      #(writeShellScriptBin "switch-to-amd" ''
      #set -e
      #switch() {
      #  systemctl stop display-manager.service
      #  /run/current-system/specialisation/amdgpu/bin/switch-to-configuration switch
      #  sleep 1
      #  shopt -s nullglob
      #  chgrp video /dev/dri/card*
      #  chgrp render /dev/dri/render*
      #  chmod g+rw /dev/dri/card* /dev/dri/render*
      #  systemctl restart display-manager.service
      #}
      #export -f switch
      #setsid bash -c switch
      #'')
      #(writeShellScriptBin "switch-to-nvidia" ''
      #set -e
      #switch() {
      #  systemctl stop display-manager.service
      #  /nix/var/nix/profiles/system/bin/switch-to-configuration switch
      #  systemctl restart display-manager.service
      #}
      #export -f switch
      #setsid bash -c switch
      #'')
    ];

    services.udev.packages = [ (pkgs.callPackage ../joycond.nix {}) ];
    systemd.services.joycond = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      script = "${pkgs.callPackage ../joycond.nix {}}/bin/joycond";
    };

    boot.kernelPackages = with pkgs; let baseLinux = linux_5_9; in recurseIntoAttrs ((linuxPackagesFor (makeOverridable (x: ((pkgs.linuxManualConfig {
      inherit stdenv;
      inherit (baseLinux) src;
      version = "${baseLinux.version}-custom";
      modDirVersion = baseLinux.modDirVersion;
      configfile = ../files/desktop-kconfig;
      allowImportFromDerivation = true;
      kernelPatches = [ {
        name = "navi-reset";
        patch = ../files/navi-reset.patch;
      } {
        name = "acs-override";
        patch = ../files/add-acs-overrides.patch;
      } ];
    }).overrideAttrs (oldAttrs: {
      passthru = oldAttrs.passthru // {
        features = {
          efiBootStub = true;
          ia32Emulation = true;
        };
      };
    }))) {})).extend (self: super: rec {
      nvidiaPackages = pkgs.dontRecurseIntoAttrs (self.callPackage ../nvidia-x11 { });

      nvidia_x11_legacy304   = nvidiaPackages.legacy_304;
      nvidia_x11_legacy340   = nvidiaPackages.legacy_340;
      nvidia_x11_legacy390   = nvidiaPackages.legacy_390;
      nvidia_x11_beta        = nvidiaPackages.beta;
      nvidia_x11_vulkan_beta = nvidiaPackages.vulkan_beta;
      nvidia_x11             = nvidiaPackages.stable;
    }));
    boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback (pkgs.callPackage ../hid-nintendo.nix { inherit (config.boot.kernelPackages) kernel; }) ];
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    boot.kernelModules = [ "kvm-amd" "i2c-piix4" "i2c-dev" "hid-nintendo" ];
    boot.kernelParams = [
      "amdgpu.ppfeaturemask=0xffff7fff" # overclocking
    ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/b1301acc-d5bf-4a8d-9738-c2aaf36660a2";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/3556-7F76";
        fsType = "vfat";
      };

    swapDevices =
      [ { device = "/dev/disk/by-uuid/13e11580-45e0-4d16-a67e-27abf1277788"; }
      ];

    nix.maxJobs = lib.mkDefault 24;
    powerManagement.cpuFreqGovernor = "performance";

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.amd.updateMicrocode = true;

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    #services.xserver.videoDrivers = [ "nvidia" ];
    #services.xserver.monitorSection = if config.services.xserver.videoDrivers == [ "nvidia" ] then ''
    #VendorName     "Unknown"
    #ModelName      "LG Electronics LG Ultra HD"
    #HorizSync       135.0 - 135.0
    #VertRefresh     40.0 - 61.0
    #'' else "";
    #services.xserver.serverLayoutSection = if config.services.xserver.videoDrivers == [ "nvidia" ] then ''
    #Option "Xinerama" "0"
    #'' else "";
    #services.xserver.screenSection = if config.services.xserver.videoDrivers == [ "nvidia" ] then ''
    #DefaultDepth    24
    #Option         "Stereo" "0"
    #Option         "nvidiaXineramaInfoOrder" "DFP-2"
    #Option         "metamodes" "3840x2160_60 +0+0 {AllowGSYNCCompatible=On}"
    #Option         "SLI" "Off"
    #Option         "MultiGPU" "Off"
    #Option         "BaseMosaic" "off"
    #SubSection     "Display"
    #    Depth       24
    #EndSubSection
    #'' else "";

    #specialisation.amdgpu.configuration = { ... }: {
    services.xserver.videoDrivers = lib.mkForce [ "amdgpu" ];
    #services.xserver.videoDrivers = lib.mkForce [ "nvidiaBeta" ];
    #services.xserver.deviceSection = ''
    #BusID "PCI:67:0:0"
    #Option "DRI" "3"
    #Option "VariableRefresh" "true"
    #'';
    #};

    #systemd.services.gpu-fixup = {
    #    description = "GPU performance fixer";
    #    wantedBy = [ "multi-user.target" ];
    #    serviceConfig.Type = "oneshot";
    #    script = ''
    #        echo manual > /sys/class/drm/card0/device/power_dpm_force_performance_level
    #    '';
    #};

    systemd.services.fanctl = {
        description = "GPU fan controller";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Restart = "always";
        script = "${pkgs.bash}/bin/bash ${../files/amdgpu-fancontrol}";
    };

    # hidpi
    services.xserver.displayManager.xserverArgs = [ "-dpi 185" ];
    console.earlySetup = true;
    console.packages = [ pkgs.terminus_font ];
    console.font = "ter-128n";
    #services.xserver.deviceSection = ''
    #Option "DRI" "3"
    #'';
    #services.xserver.serverFlagsSection = ''
    #Option "AutoAddGPU" "off"
    #'';
    services.xserver.exportConfiguration = true;

    #hardware.pulseaudio.extraConfig = ''
    #load-module module-remap-sink sink_name=reverse-stereo master=alsa_output.pci-0000_0a_00.3.analog-stereo channels=2 master_channel_map=front-right,front-left channel_map=front-left,front-right
    #set-default-sink reverse-stereo
    #'';
    hardware.pulseaudio.daemon.config = {
      default-sample-format = "s32le";
      #default-sample-rate = 192000;
    };

    systemd.sleep.extraConfig = "HibernateMode=reboot";

    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.services.rngd.conflicts = [ "shutdown.target" ];
    systemd.services.rngd.before = [ "sysinit.target" "shutdown.target" ];
    boot.loader.timeout = null;

    systemd.shutdown.reset-gpu = pkgs.writeScript "reset-gpu" ''
    #!${pkgs.bash}/bin/bash
    [[ "$1" == "kexec" ]] || exit
    echo 0000:43:00.0 > /sys/bus/pci/devices/0000\:43\:00.0/driver/unbind || true
    echo 0000:43:00.1 > /sys/bus/pci/devices/0000\:43\:00.1/driver/unbind || true
    echo 1 > /sys/bus/pci/devices/0000\:43\:00.0/reset
    '';
  };

  nixops = {
    deployment.targetHost = "192.168.1.131";
  };

  system = "x86_64-linux";
}
