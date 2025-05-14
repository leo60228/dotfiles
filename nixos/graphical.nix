# vi: set foldmethod=marker:

{
  config,
  lib,
  pkgs,
  ...
}:

{
  options = {
    vris.graphical = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    vris.gpuSupportsStats = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    vris.firefox = lib.mkOption {
      type = lib.types.package;
      default = pkgs.firefox-devedition;
    };
  };

  config = lib.mkIf config.vris.graphical {
    # Core {{{1
    services.xserver.enable = true;
    services.libinput.enable = true;
    programs.dconf.enable = true;
    services.flatpak.enable = true;
    networking.networkmanager.enable = true;

    # Sound {{{1
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    systemd.user.services.wireplumber.environment.ACP_PROFILES_DIR = ../files/profile-sets;

    # Fonts {{{1
    fonts.enableDefaultPackages = false;
    fonts.packages = with pkgs; [
      dejavu_fonts
      freefont_ttf
      gyre-fonts
      liberation_ttf
      unifont
      unifont_upper
      noto-fonts
      noto-fonts-cjk-sans
      corefonts
    ];
    fonts.fontconfig.cache32Bit = pkgs.stdenv.isx86_64;

    # mpd {{{1
    services.mpd = {
      enable = true;
      startWhenNeeded = true;
      user = "leo60228";
      group = "users";
      musicDirectory = "/home/leo60228/Music";
      playlistDirectory = "/home/leo60228/Playlists";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire"
        }
        replaygain "track"
        replaygain_preamp "5"
      '';
      network.listenAddress = "any";
    };
    systemd.services.mpd.environment = {
      XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.leo60228.uid}";
      PIPEWIRE_CONFIG_NAME = "client-rt.conf";
    };

    security.pam.loginLimits = [
      {
        domain = "@wheel";
        type = "-";
        item = "rtprio";
        value = "95";
      }
      {
        domain = "@wheel";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
    ];

    # KDE {{{1
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm = {
      enable = true;
      enableHidpi = true;
      theme = "breeze-user";
    };

    programs.kdeconnect.enable = true;

    environment.systemPackages = [
      pkgs.kdePackages.sddm-kcm
      pkgs.kdePackages.breeze-icons

      pkgs.exfatprogs
      pkgs.leoPkgs.sddm-theme-breeze-user

      pkgs.aspell
      pkgs.aspellDicts.en
      pkgs.aspellDicts.en-computers
    ] ++ lib.optional config.hardware.bluetooth.enable pkgs.kdePackages.bluedevil;

    environment.etc."/etc/aspell.conf".text = ''
      master en_US
      extra-dicts en-computers.rws
      add-extra-dicts en_US-science.rws
    '';

    xdg = {
      icons.enable = true;
      portal = {
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        xdgOpenUsePortal = true;
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_DISABLE_RDD_SANDBOX = "1";
      QT_LOGGING_RULES = "*.debug=false";

      GTK_USE_PORTAL = 1;
      GDK_DEBUG = "portals";
      PLASMA_INTEGRATION_USE_PORTAL = 1;
    };
    # }}}
  };
}
