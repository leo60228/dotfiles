# vi: set foldmethod=marker:
{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  nix.settings.max-jobs = lib.mkDefault 24;

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
  ];
  boot.extraModprobeConfig = ''
    options kvm-amd nested=1
  '';

  boot.extraModulePackages = [ (pkgs.leoPkgs.datapath-vision config.boot.kernelPackages) ];
  hardware.firmware = [ pkgs.leoPkgs.datapath-vision-firmware ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Boot {{{1
  boot.loader.systemd-boot = {
    enable = true;
    memtest86.enable = true;
  };

  # Disks {{{1
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b1301acc-d5bf-4a8d-9738-c2aaf36660a2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/3556-7F76";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/13e11580-45e0-4d16-a67e-27abf1277788"; } ];

  # Graphics {{{1
  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-tools
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
  services.xserver.displayManager.xserverArgs = [ "-dpi 157" ];
  console.earlySetup = true;
  console.packages = [ pkgs.terminus_font ];
  console.font = "ter-128n";
  services.xserver.exportConfiguration = true;
  services.displayManager.sddm.settings = {
    General = {
      Numlock = "none";
    };

    Theme = {
      CursorSize = 48;
      CursorTheme = "breeze_cursors";
      Font = "Sans Serif,10,-1,5,50,0,0,0,0,0";
    };

    X11 = {
      ServerArguments = "-dpi 192";
    };
  };
  services.xserver.displayManager.setupCommands = ''
    echo 'Xcursor.theme: breeze_cursors' | ${pkgs.xorg.xrdb}/bin/xrdb -nocpp -merge
  '';

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
  # }}}

  deployment.tags = [ "workstation" ];
  deployment.allowLocalDeployment = true;
}
