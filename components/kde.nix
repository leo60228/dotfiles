let lib = import ../lib; in
lib.makeComponent "kde"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    bluetooth = mkOption {
      default = true;
      type = types.bool;
    };

    plasma6 = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkMerge [ {
    # Enable the KDE Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.enableHidpi = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.MOZ_DISABLE_RDD_SANDBOX = "1";

    qt = {
      enable = true;
      platformTheme = "kde";
    };
  } (mkIf (!cfg.plasma6) {
    environment.systemPackages = with pkgs; [
      plasma-nm plasma-pa plasma5Packages.kde-gtk-config plasma5Packages.sddm-kcm kdePackages.breeze skanpage isoimagewriter krdc neochat konversation
    ];

    services.xserver.desktopManager.plasma5.enable = true;
  }) (mkIf cfg.plasma6 {
    environment.systemPackages = with pkgs.kdePackages; [
      sddm-kcm audiocd-kio skanpage isoimagewriter krdc neochat konversation
    ];

    services.xserver.desktopManager.plasma6.enable = true;
  }) (mkIf cfg.bluetooth {
    hardware.bluetooth.enable = true;

    # software support
    environment.systemPackages = with pkgs; [ bluedevil ];
  }) ];
})
