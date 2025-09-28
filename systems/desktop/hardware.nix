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
    flakes.lanzaboote.nixosModules.lanzaboote
  ];

  nix.settings.max-jobs = lib.mkDefault 48;

  # Kernel {{{1
  boot.kernelPackages = pkgs.linuxPackages_6_6;
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = [
    # SATA
    "ahci"
    "sd_mod"
    "nvme"

    # USB
    "xhci_hcd"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "hid_generic"

    # x86 keyboard
    "atkbd"
    "i8042"

    # RTC
    "rtc_cmos"
  ];
  boot.initrd.kernelModules = [
    "dm_mod"
    "dm-snapshot"
  ];
  boot.kernelModules = [
    "kvm-amd"
    "i2c-piix4"
    "i2c-dev"
    "edac_mce_amd"
    "rgb133"
    "HwsUHDX1Capture"
  ];
  boot.extraModprobeConfig = ''
    options kvm-amd nested=1
  '';

  boot.extraModulePackages = [
    (pkgs.leoPkgs.avmvc12.override { linuxPackages = config.boot.kernelPackages; })
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Boot {{{1
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.initrd.systemd.enable = true;

  # Disks {{{1
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  fileSystems."/" = {
    device = "rpool/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3556-7F76";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-partuuid/7ce37c65-7e1f-4dc9-bc7f-90f388eec3e3";
      randomEncryption = {
        enable = true;
        allowDiscards = true;
        sectorSize = 4096;
      };
    }
  ];

  vris.zfs-credstore = {
    enable = true;
    devices = [
      "/dev/disk/by-id/nvme-TEAM_TM8FP4004T_1B2310020140078-part2"
    ];
  };

  # Graphics {{{1
  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-tools
    sbctl
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libvdpau-va-gl
    ];
  };

  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
  services.xserver.screenSection = ''
    Option "metamodes" "nvidia-auto-select +0+0 {AllowGSYNCCompatible=On}"
  '';

  hardware.nvidia-container-toolkit.enable = true;
  vris.gpuSupportsStats = true;

  # HiDPI {{{1
  console.earlySetup = true;
  console.packages = [ pkgs.terminus_font ];
  console.font = "ter-128n";

  services.displayManager.sddm.wayland.enable = true;

  # Sound {{{1
  services.udev.extraRules = ''
    SUBSYSTEM!="sound", GOTO="pipewire_end"
    ACTION!="change", GOTO="pipewire_end"
    KERNEL!="card*", GOTO="pipewire_end"

    SUBSYSTEMS=="pci", ATTRS{vendor}=="0x1022", ATTRS{device}=="0x1457", ENV{ACP_PROFILE_SET}="reversed-speakers.conf"

    LABEL="pipewire_end"
  '';

  # Workarounds {{{1
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.rngd.conflicts = [ "shutdown.target" ];
  systemd.services.rngd.before = [
    "sysinit.target"
    "shutdown.target"
  ];
  powerManagement.cpuFreqGovernor = "performance";
  # }}}

  deployment.tags = [ "workstation" ];
  deployment.allowLocalDeployment = true;
}
