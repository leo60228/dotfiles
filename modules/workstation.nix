# vi: set foldmethod=marker:

{
  config,
  flakes,
  lib,
  pkgs,
  ...
}:

{
  options = {
    vris.workstation = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.vris.workstation {
    # Packages {{{
    hardware.enableAllFirmware = true;
    services.pcscd.enable = true;
    programs.java.enable = true;
    networking.networkmanager.enable = true;
    programs.bash.completion.enable = true;
    programs.nix-ld.enable = true;
    boot.supportedFilesystems = [ "ntfs" ];

    environment.systemPackages =
      [
        pkgs.androidenv.androidPkgs.platform-tools
        pkgs.openocd
      ]
      ++ lib.optionals config.vris.graphical [
        pkgs.kdePackages.sddm-kcm
        pkgs.kdePackages.audiocd-kio
        pkgs.kdePackages.skanpage
        pkgs.kdePackages.isoimagewriter
        pkgs.kdePackages.krdc
        pkgs.kdePackages.neochat
        pkgs.kdePackages.konversation
        pkgs.kdePackages.discover
        pkgs.kdePackages.partitionmanager
        pkgs.kdePackages.kclock
        (flakes.rom-properties.packages.${pkgs.system}.rp_kde6.overrideAttrs (oldAttrs: {
          patches = oldAttrs.patches ++ [ ../files/rp_larger_icons.diff ];
        }))
      ];
    # }}}

    # Avahi {{{
    services.avahi = {
      enable = true;
      allowPointToPoint = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        domain = true;
        addresses = true;
      };
    };
    # }}}

    # Printing {{{
    services.printing = {
      enable = true;
      drivers = [
        pkgs.hplip
        pkgs.gutenprint
        pkgs.gutenprintBin
      ];
    };
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
    users.extraUsers.leo60228.extraGroups = [ "scanner" ];
    # }}}

    # Configuration {{{
    programs.fuse.userAllowOther = true;
    programs.command-not-found.dbPath =
      flakes.flake-programs-sqlite.packages.${pkgs.system}.programs-sqlite;
    # }}}

    # Debuggers {{{
    services.udev.packages = [
      pkgs.android-udev-rules
      pkgs.platformio-core
      pkgs.openocd
    ];
    # }}}
  };
}
