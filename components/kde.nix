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
      plasma-nm plasma-pa plasma5.kde-gtk-config latte-dock
    ];

    # Enable the KDE Desktop Environment.
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.enableHidpi = true;
    services.xserver.desktopManager.plasma5.enable = true;

    nixpkgs.overlays = [ (import ../nixpkgs/kio-extras.nix) ];
  } (mkIf cfg.bluetooth {
    hardware.bluetooth.enable = true;

    # software support
    environment.systemPackages = with pkgs; [ bluedevil ];
    hardware.pulseaudio = with pkgs; {
      enable = true;
      extraModules = [ pulseaudio-modules-bt ];
      package = pulseaudioFull;
    };
  }) ];
})
