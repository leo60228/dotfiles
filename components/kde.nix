let lib = import ../lib; in
lib.makeComponent "kde"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    bluetooth = mkOption {
      default = true;
      type = types.bool;
    };
  };

  config = mkMerge [ {
    environment.systemPackages = with pkgs; [
      plasma-nm plasma-pa plasma5Packages.kde-gtk-config latte-dock
    ];

    # Enable the KDE Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.enableHidpi = true;
    services.xserver.desktopManager.plasma5.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.MOZ_DISABLE_RDD_SANDBOX = "1";
  } (mkIf cfg.bluetooth {
    hardware.bluetooth.enable = true;

    # software support
    environment.systemPackages = with pkgs; [ bluedevil ];
  }) ];
})
