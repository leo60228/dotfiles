let lib = import ../lib; in
lib.makeComponent "extra"
({config, cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    security.sudo.wheelNeedsPassword = false;

    services.pcscd.enable = true;
    
    hardware.enableAllFirmware = true;
    
    # exfat
    #boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

    # java
    programs.java.enable = true;
    programs.java.package = pkgs.jre;

    # printer
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplip pkgs.gutenprint pkgs.gutenprintBin ];
    
    environment.systemPackages = with pkgs; [
      wget vim qemu
    ];
    
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

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0955", ATTR{idProduct}=="7321", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="8b00", MODE="0666"
    '';
  };
})
