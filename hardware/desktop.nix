{
  nixos = { config, lib, pkgs, ... }:
  {
    imports =
      [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ];

    environment.systemPackages = with pkgs; [
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

    #boot.kernelPackages = kernelPkgs.linuxPackages_latest;
    boot.kernelPackages = pkgs.linuxPackages_5_8;
    boot.kernelPatches = [ {
      name = "navi-reset";
      patch = ../files/navi-reset.patch;
    } {
      name = "acs-override";
      patch = ../files/add-acs-overrides.patch;
    } ];
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    boot.kernelModules = [ "kvm-amd" "i2c-piix4" "i2c-dev" ];
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

    nix.maxJobs = lib.mkDefault 12;
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
    services.xserver.deviceSection = ''
    BusID "PCI:67:0:0"
    '';
    #};

    #systemd.services.gpu-fixup = {
    #    description = "GPU performance fixer";
    #    wantedBy = [ "multi-user.target" ];
    #    serviceConfig.Type = "oneshot";
    #    script = ''
    #        echo manual > /sys/class/drm/card0/device/power_dpm_force_performance_level
    #    '';
    #};

    #systemd.services.fanctl = {
    #    description = "GPU fan controller";
    #    wantedBy = [ "multi-user.target" ];
    #    serviceConfig.Restart = "always";
    #    script = "${../files/fanctl} -c ${../files/fanctl.yml}";
    #};

    # hidpi
    services.xserver.displayManager.xserverArgs = [ "-dpi 185" ];
    console.earlySetup = true;
    console.packages = [ pkgs.terminus_font ];
    console.font = "ter-128n";
    #services.xserver.deviceSection = ''
    #Option "DRI" "3"
    #BusID "PCI:8:0:0"
    #'';
    #services.xserver.serverFlagsSection = ''
    #Option "AutoAddGPU" "off"
    #'';
    services.xserver.exportConfiguration = true;

    hardware.pulseaudio.extraConfig = ''
    load-module module-remap-sink sink_name=reverse-stereo master=alsa_output.pci-0000_0d_00.4.analog-stereo channels=2 master_channel_map=front-right,front-left channel_map=front-left,front-right
    set-default-sink reverse-stereo
    '';

    systemd.sleep.extraConfig = "HibernateMode=reboot";

    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.services.rngd.conflicts = [ "shutdown.target" ];
    systemd.services.rngd.before = [ "sysinit.target" "shutdown.target" ];
    boot.loader.timeout = null;
  };

  nixops = {
    deployment.targetHost = "192.168.1.131";
  };
}
