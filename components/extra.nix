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
    programs.java.package = if cfg.graalvm then pkgs.graalvm17-ee else pkgs.adoptopenjdk-hotspot-bin-8;

    # printer
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplip pkgs.gutenprint pkgs.gutenprintBin ];

    programs.bash.enableCompletion = true;

    networking.networkmanager.enable = true; # Enable NetworkManager to manage Wi-Fi connections

    services.avahi.enable = true;
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
    ];

    # ntfs
    boot.supportedFilesystems = [ "ntfs" ];
  };
})
