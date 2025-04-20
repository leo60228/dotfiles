let
  lib = import ../lib;
in
lib.makeComponent "extra" (
  {
    config,
    cfg,
    pkgs,
    lib,
    flakes,
    ...
  }:
  with lib;
  {
    opts = {
      graalvm = mkOption {
        default = false;
        type = types.bool;
      };
    };

    config = {
      vris.workstation = true;

      # mpd
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
    };
  }
)
