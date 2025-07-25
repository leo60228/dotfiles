# vi: set foldmethod=marker:

{
  config,
  lib,
  modulesPath,
  pkgs,
  flakes,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
    flakes.nixos-hardware.nixosModules.framework-13-7040-amd
    flakes.lanzaboote.nixosModules.lanzaboote
  ];

  config = {
    services.power-profiles-daemon.enable = true;
    services.hardware.bolt.enable = true;
    services.udisks2.package = pkgs.leoPkgs.udisks2;
    vris.gpuSupportsStats = true;

    networking.networkmanager.wifi.backend = "iwd";

    deployment.tags = [ "workstation" ];
    deployment.allowLocalDeployment = true;

    # Kernel {{{1
    boot.kernelPackages = pkgs.linuxPackages_testing;
    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "thunderbolt"
      "usb_storage"
      "sd_mod"
    ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    boot.extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
      options amdgpu dcdebugmask=0x10
      options snd-hda-intel patch=hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw,hda-jack-retask.fw power_save=0
      options ttm pages_limit=8037464
    '';

    networking.wireless.iwd.settings = {
      General.ControlPortOverNL80211 = false;
      Rank.BandModifier6GHz = 1.1;
    };

    # Disks {{{1
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/41691e95-8ec6-45a9-8f0e-6a3c72fd6c70";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/5EBE-7AB7";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [ { device = "/dev/disk/by-uuid/f735a083-e7e4-46ca-a0b0-73f280f3d8ad"; } ];

    boot.initrd.luks.devices."lvm".device = "/dev/disk/by-uuid/32bfc36e-2640-4110-bc58-b93564acaafa";

    # Boot {{{1
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    environment.systemPackages = [
      pkgs.sbctl
      pkgs.kdePackages.plasma-thunderbolt
    ];

    # HiDPI {{{1
    console.earlySetup = true;
    console.packages = [ pkgs.terminus_font ];
    console.font = "ter-128n";

    services.displayManager.sddm.wayland.enable = true;

    # Sound {{{1
    hardware.framework.laptop13.audioEnhancement = {
      enable = true;
      rawDeviceName = "alsa_output.pci-0000_c1_00.6.analog-stereo-speaker";
    };

    environment.etc."alsa-card-profile/mixer/paths/analog-output-speaker-split.conf".source =
      ../../files/analog-output-speaker-split.conf;
    services.udev.extraRules = ''
      SUBSYSTEM!="sound", GOTO="pipewire_end"
      ACTION!="change", GOTO="pipewire_end"
      KERNEL!="card*", GOTO="pipewire_end"

      SUBSYSTEMS=="pci", ATTRS{vendor}=="0x1022", ATTRS{device}=="0x15e3", ENV{ACP_PROFILE_SET}="${../../files/split-ports-profile.conf}"

      LABEL="pipewire_end"
    '';

    hardware.firmware = [
      (pkgs.runCommand "hda-jack-retask-fw" { } ''
        mkdir -p $out/lib/firmware
        cp ${../../files/hda-jack-retask.fw} $out/lib/firmware/hda-jack-retask.fw
      '')
    ];
    hardware.alsa.enablePersistence = true;
    systemd.services.alsa-store.serviceConfig.ExecStart =
      lib.mkForce "-${pkgs.alsa-utils}/sbin/alsactl restore --ignore";

    # Fingerprint {{{1
    security.pam.services.polkit-1.fprintAuth = true;
    security.pam.services.polkit-1.rules.auth.fprintd.modulePath =
      lib.mkForce "${pkgs.leoPkgs.pam-fprint-grosshack}/lib/security/pam_fprintd_grosshack.so";
  };

  options.security.pam.services = lib.mkOption {
    type =
      with lib.types;
      attrsOf (
        submodule (
          { ... }:
          {
            config.fprintAuth = lib.mkDefault false;
          }
        )
      );
  };
  # }}}
}
