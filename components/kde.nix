let
  lib = import ../lib;
in
lib.makeComponent "kde" (
  {
    cfg,
    pkgs,
    lib,
    flakes,
    ...
  }:
  with lib;
  {
    opts = {
      bluetooth = mkOption {
        default = true;
        type = types.bool;
      };
    };

    config = mkMerge [
      {
        # Enable the KDE Desktop Environment.
        services.displayManager.sddm.enable = true;
        services.displayManager.sddm.enableHidpi = true;
        services.displayManager.sddm.theme = "breeze-user";

        environment.sessionVariables.NIXOS_OZONE_WL = "1";
        environment.sessionVariables.MOZ_DISABLE_RDD_SANDBOX = "1";
        environment.sessionVariables.QT_LOGGING_RULES = "*.debug=false";

        qt = {
          enable = true;
          platformTheme = "kde";
        };

        environment.systemPackages = with pkgs.kdePackages; [
          sddm-kcm
          audiocd-kio
          skanpage
          isoimagewriter
          krdc
          neochat
          konversation
          breeze-icons
          discover
          partitionmanager
          kclock
          pkgs.exfatprogs
          (flakes.rom-properties.packages.${pkgs.system}.rp_kde6.overrideAttrs (oldAttrs: {
            patches = oldAttrs.patches ++ [ ../files/rp_larger_icons.diff ];
          }))
          pkgs.leoPkgs.sddm-theme-breeze-user
        ];

        services.desktopManager.plasma6.enable = true;
        xdg.icons.enable = true;

        xdg.portal = {
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          xdgOpenUsePortal = true;
        };
        environment.sessionVariables = {
          GTK_USE_PORTAL = 1;
          GDK_DEBUG = "portals";
          PLASMA_INTEGRATION_USE_PORTAL = 1;
        };
      }
      (mkIf cfg.bluetooth {
        hardware.bluetooth.enable = true;

        # software support
        environment.systemPackages = [ pkgs.kdePackages.bluedevil ];
      })
    ];
  }
)
