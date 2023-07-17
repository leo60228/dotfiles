let lib = import ../lib; in
lib.makeComponent "extra"
({config, cfg, pkgs, lib, ...}: with lib; {
  opts = {
    graalvm = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = {
    services.pcscd.enable = true;

    hardware.enableAllFirmware = true;

    # exfat
    #boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

    # java
    programs.java.enable = true;
    programs.java.package = if cfg.graalvm then pkgs.graalvm17-ce else pkgs.adoptopenjdk-hotspot-bin-8;

    # printer
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplip pkgs.gutenprint pkgs.gutenprintBin ];

    programs.bash.enableCompletion = true;

    networking.networkmanager.enable = true; # Enable NetworkManager to manage Wi-Fi connections

    services.avahi.enable = true;
    services.avahi.allowPointToPoint = true;
    services.avahi.nssmdns = true;
    services.avahi.publish.enable = true;
    services.avahi.publish.domain = true;
    services.avahi.publish.addresses = true;

    environment.etc."fuse.conf".text = ''
      user_allow_other
    '';

    # adb
    services.udev.packages = [ pkgs.android-udev-rules ];

    environment.systemPackages = with pkgs; [
      wget vim androidenv.androidPkgs_9_0.platform-tools
    ] ++ lib.optionals config.services.xserver.enable [ linux-wifi-hotspot ];

    # ntfs
    boot.supportedFilesystems = [ "ntfs" ];

    # capture card
    services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="video4linux", ENV{ID_VENDOR}="VXIS_Inc", ENV{ID_V4L_CAPABILITIES}=="*:capture:*", RUN+="${pkgs.writeScript "setup-capture" ''
    #!/bin/sh
    export PATH=${pkgs.leoPkgs.vxis-capture-fw-mod}/bin:${pkgs.v4l-utils}/bin:$PATH

    # Disable black point adjustment
    i2c_vs9989 -w 0x38 0 "$DEVNAME"

    # disable sharpness/contrast/color processing
    xdata -w 0x2170 0x80 "$DEVNAME"

    # Set good ramps
    v4l2-ctl -d "$DEVNAME" -c brightness=143
    v4l2-ctl -d "$DEVNAME" -c contrast=110
    v4l2-ctl -d "$DEVNAME" -c saturation=148

    # Fix chroma siting
    i2c_vs9989 -w 0x35 0x28 "$DEVNAME"
    i2c_vs9989 -w 0x8d 0x48 "$DEVNAME"
    ''}"
    '';
  };
})
