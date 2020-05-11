{
  nixos = { config, lib, pkgs, ... }:
  let mesaPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/94d88d3b70916f02ec86bf08945c20bdf5526cc2.tar.gz";
    sha256 = "1ximzgp1vk8d7055hhz8pl287iy3afph7n4ldj6645ynri5gpyqr";
  }) {};
      s3tcSupport = false;
      makeDriverPackage = p: p.buildEnv {
        name = "mesa-drivers+txc-${p.mesa.version}";
        paths =
          [ p.mesa.drivers
            (if s3tcSupport then p.libtxc_dxtn else p.libtxc_dxtn_s2tc)
          ];
      };
      kernelPkgs = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/4fbd9e3ab8b9ff17108371b71db20644747536c6.tar.gz";
        sha256 = "1s51ps9psds19abjh09dsrlrg9qadgyc7k25b9krj4fkfqb3fr9p";
      }) {
        config.allowUnfree = true;
      };
  in {
    imports =
      [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
      ];

    environment.systemPackages = with pkgs; [ vulkan-loader vulkan-tools (writeShellScriptBin "switch-to-amd" ''
    set -e
    switch() {
      systemctl stop display-manager.service
      /run/current-system/fine-tune/child-1/bin/switch-to-configuration switch
      systemctl restart display-manager.service
    }
    export -f switch
    setsid bash -c switch
    '') (writeShellScriptBin "switch-to-nvidia" ''
    set -e
    switch() {
      systemctl stop display-manager.service
      /nix/var/nix/profiles/system/bin/switch-to-configuration switch
      systemctl restart display-manager.service
    }
    export -f switch
    setsid bash -c switch
    '')];

    #boot.kernelPackages = kernelPkgs.linuxPackages_latest;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelPatches = [ {
      name = "navi-reset";
      patch = ../files/navi-reset.patch;
    } {
      name = "acs-override";
      patch = ../files/add-acs-overrides.patch;
    } {
      name = "ryzen-3-usb-flr";
      patch = ../files/ryzen-3-usb-flr.patch;
    }];
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.kernelParams = [
      "amdgpu.ppfeaturemask=0xffff7fff" # overclocking
      "idle=nomwait" # possible workaround to hangs
      "video=efifb:off"
      "pcie_acs_override=downstream,multifunction"
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

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.enableRedistributableFirmware = true;
    hardware.cpu.amd.updateMicrocode = true;
    services.xserver.monitorSection = if config.services.xserver.videoDrivers == [ "nvidia" ] then ''
    VendorName     "Unknown"
    ModelName      "LG Electronics LG Ultra HD"
    HorizSync       135.0 - 135.0
    VertRefresh     40.0 - 61.0
    '' else "";
    services.xserver.serverLayoutSection = if config.services.xserver.videoDrivers == [ "nvidia" ] then ''
    Option "Xinerama" "0"
    '' else "";
    services.xserver.screenSection = if config.services.xserver.videoDrivers == [ "nvidia" ] then ''
    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "nvidiaXineramaInfoOrder" "DFP-2"
    Option         "metamodes" "3840x2160_60 +0+0 {AllowGSYNCCompatible=On}"
    Option         "SLI" "Off"
    Option         "MultiGPU" "Off"
    Option         "BaseMosaic" "off"
    SubSection     "Display"
        Depth       24
    EndSubSection
    '' else "";

    nesting.clone = [ ({ ... }: {
      services.xserver.videoDrivers = lib.mkForce [ "amdgpu" ];
      hardware.opengl.package = makeDriverPackage mesaPkgs;
      hardware.opengl.package32 = makeDriverPackage mesaPkgs.pkgsi686Linux;

      system.activationScripts.vfio = lib.mkForce {
        deps = [];
        text = ''
        GPU=0b:00
        GPU_ID="1002 731f"
        GPU_AUDIO_ID="1002 ab38"

        # Unbind the GPU from vfio-pci
        echo -n "0000:''${GPU}.0" > /sys/bus/pci/drivers/vfio-pci/unbind 2>/dev/null || true
        echo -n "0000:''${GPU}.1" > /sys/bus/pci/drivers/vfio-pci/unbind 2>/dev/null || true

        # Remove GPU from vfio-pci
        echo -n "$GPU_ID" > /sys/bus/pci/drivers/vfio-pci/remove_id
        echo -n "$GPU_AUDIO_ID" > /sys/bus/pci/drivers/vfio-pci/remove_id

        # Bind the GPU to it's drivers
        echo -n "0000:''${GPU}.0" > /sys/bus/pci/drivers/amdgpu/bind 2>/dev/null || true
        echo -n "0000:''${GPU}.1" > /sys/bus/pci/drivers/snd_hda_intel/bind 2>/dev/null || true
        '';
      };
    }) ];

    system.activationScripts.vfio = {
      deps = [];
      text = ''
      GPU=0b:00
      GPU_ID="1002 731f"
      GPU_AUDIO_ID="1002 ab38"

      # Unbind the GPU from it's drivers
      echo -n "0000:''${GPU}.0" > /sys/bus/pci/drivers/amdgpu/unbind 2>/dev/null || true
      echo -n "0000:''${GPU}.1" > /sys/bus/pci/drivers/snd_hda_intel/unbind 2>/dev/null || true

      # Hand over GPU to vfio-pci
      echo -n "$GPU_ID" > /sys/bus/pci/drivers/vfio-pci/new_id 2>/dev/null || true
      echo -n "$GPU_AUDIO_ID" > /sys/bus/pci/drivers/vfio-pci/new_id 2>/dev/null || true
      '';
    };

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

    systemd.services.systemd-udev-settle.enable = false;
    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.services.rngd.conflicts = [ "shutdown.target" ];
    systemd.services.rngd.before = [ "sysinit.target" "shutdown.target" ];
    boot.loader.timeout = null;
  };

  nixops = {
    deployment.targetHost = "192.168.1.131";
  };
}
