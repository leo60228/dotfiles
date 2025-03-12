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
      services.pcscd.enable = true;

      hardware.enableAllFirmware = true;

      # exfat
      #boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];

      # java
      programs.java.enable = true;
      programs.java.package = if cfg.graalvm then pkgs.graalvm-ce else pkgs.jdk;

      # printer
      services.printing.enable = true;
      services.printing.drivers = [
        pkgs.hplip
        pkgs.gutenprint
        pkgs.gutenprintBin
      ];
      hardware.sane.enable = true;
      hardware.sane.extraBackends = [ pkgs.sane-airscan ];
      users.extraUsers.leo60228.extraGroups = [ "scanner" ];

      programs.bash.completion.enable = true;

      networking.networkmanager.enable = true; # Enable NetworkManager to manage Wi-Fi connections

      services.avahi.enable = true;
      services.avahi.allowPointToPoint = true;
      services.avahi.nssmdns4 = true;
      services.avahi.publish.enable = true;
      services.avahi.publish.domain = true;
      services.avahi.publish.addresses = true;

      environment.etc."fuse.conf".text = ''
        user_allow_other
      '';

      # adb
      services.udev.packages = [
        pkgs.android-udev-rules
        pkgs.platformio-core
        pkgs.openocd
        #pkgs.bloom
      ];

      environment.systemPackages =
        with pkgs;
        [
          wget
          vim
          androidenv.androidPkgs.platform-tools
        ]
        ++ lib.optionals config.services.xserver.enable [
          linux-wifi-hotspot
          waypipe
        ];

      # ntfs
      boot.supportedFilesystems = [ "ntfs" ];

      # capture card
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="video4linux", ENV{ID_VENDOR}="VXIS_Inc", ENV{ID_V4L_CAPABILITIES}=="*:capture:*", RUN+="${pkgs.writeScript "setup-capture" ''
          #!/bin/sh
          export PATH=${pkgs.leoPkgs.vxis-capture-fw-mod}/bin:${pkgs.v4l-utils}/bin:$PATH

          # Disable black point adjustment
          i2c_vs9989 -w 0x38 0 "$DEVNAME"

          # disable sharpness/contrast/color processing
          xdata -w 0x2170 0x80 "$DEVNAME"

          # Set good ramps
          v4l2-ctl -d "$DEVNAME" -c brightness=143
          v4l2-ctl -d "$DEVNAME" -c contrast=110
          v4l2-ctl -d "$DEVNAME" -c saturation=148

          # Fix chroma siting
          i2c_vs9989 -w 0x35 0x28 "$DEVNAME"
          i2c_vs9989 -w 0x8d 0x48 "$DEVNAME"
        ''}"
      '';

      # nix-ld
      programs.nix-ld.enable = true;

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

      security.pam.loginLimits = [
        { domain = "@wheel"; type = "-"; item = "rtprio"; value = "95"; }
        { domain = "@wheel"; type = "-"; item = "memlock"; value = "unlimited"; }
      ];

      programs.command-not-found.dbPath =
        flakes.flake-programs-sqlite.packages.${pkgs.system}.programs-sqlite;
    };
  }
)
