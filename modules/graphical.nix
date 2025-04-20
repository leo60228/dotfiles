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
  };

  config = lib.mkIf config.vris.graphical {
    # Core {{{
    services.xserver.enable = true;
    services.libinput.enable = true;
    programs.dconf.enable = true;
    # }}}

    # Sound {{{
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    systemd.user.services.wireplumber.environment.ACP_PROFILES_DIR = ../files/profile-sets;
    # }}}

    # Fonts {{{
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
    fonts.fontconfig.cache32Bit = true;
    # }}}

    # mpd {{{
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
    # }}}
  };
}
