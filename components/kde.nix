let lib = import ../lib; in
lib.makeComponent "kde"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    bluetooth = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkMerge [ {
    environment.systemPackages = with pkgs; [
      plasma-nm plasma-pa plasma5.kde-gtk-config latte-dock
    ];

    # Enable the KDE Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
  } (mkIf cfg.bluetooth {
    hardware.bluetooth.enable = true;

    # software support
    environment.systemPackages = with pkgs; [ bluedevil ];
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
  }) ];
})