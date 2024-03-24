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
    # Enable the KDE Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.enableHidpi = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.sessionVariables.MOZ_DISABLE_RDD_SANDBOX = "1";
    environment.sessionVariables.QT_LOGGING_RULES = "*.debug=false";

    qt = {
      enable = true;
      platformTheme = "kde";
    };

    environment.systemPackages = with pkgs.kdePackages; [
      sddm-kcm audiocd-kio skanpage isoimagewriter krdc neochat konversation breeze-icons discover
    ];

    services.desktopManager.plasma6.enable = true;
    xdg.icons.enable = true;
  } (mkIf cfg.bluetooth {
    hardware.bluetooth.enable = true;

    # software support
    environment.systemPackages = [ pkgs.kdePackages.bluedevil ];
  }) ];
})
