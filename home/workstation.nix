{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.vris.workstation {
  home.packages = with pkgs; [
    unixtools.xxd
    (beets.override {
      pluginOverrides.filetote = {
        enable = true;
        propagatedBuildInputs = [ beetsPackages.filetote ];
      };
    })
    docker-credential-helpers
    libsecret
    parsec-bin
    leoPkgs.redumper
    wiimms-iso-tools
    leoPkgs.hactoolnet
    colmena
    fusee-nano
    obs-studio
    ares
    ryujinx
    ctrtool
    hactool
    qpwgraph
    leoPkgs.eontimer
    jetbrains-toolbox
    rsgain
    kio-fuse
    gitAndTools.lab
    bitwarden-cli
    cargo-edit
    qbittorrent
    nix-prefetch-github
    element-desktop
    mosquitto
    rclone
    (hiPrio rustup)
    lftp
    dolphin-emu-beta
    gdb
    easytag
    nodejs_latest
    nix-prefetch-git
    audacity
    ffmpeg
    gnupg
    pkg-config
    yt-dlp
    leoPkgs.rust.rust
    libreoffice
    gitAndTools.hub
    prismlauncher
    mgba
    wineWowPackages.staging
    gnumake
    (hiPrio gcc)
    hplip
    dotnet-sdk
    mono
    leoPkgs.vscode-fhs
    yubikey-touch-detector
  ];

  programs.git.package = pkgs.gitAndTools.gitFull;
  programs.bash.initExtra = ''
    eval $(hub alias -s)
  '';
  programs.bash.shellAliases = {
    ffmpeg = "ffmpeg -hide_banner";
    ffplay = "ffplay -hide_banner";
    ffprobe = "ffprobe -hide_banner";
  };

  programs.go.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    grabKeyboardAndMouse = false;
    pinentry.package = pkgs.pinentry-qt;
  };
  programs.git.signing.signByDefault = true;

  systemd.user.services.yubikey-touch-detector = {
    Unit = {
      Description = "Detects when your YubiKey is waiting for a touch";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.yubikey-touch-detector}/bin/yubikey-touch-detector --libnotify";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  home.file.".rustup/toolchains/system".source = pkgs.leoPkgs.rust.rust;

  home.file.".gradle/gradle.properties" = {
    text = ''
      org.gradle.java.installations.paths=${pkgs.jdk8}
      org.gradle.java.installations.auto-download=false
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      eval _orig_"$(declare -f use_nix)"
      use_nix() {
        _orig_use_nix "$@"
        unset IN_NIX_SHELL
      }

      eval _orig_"$(declare -f use_flake)"
      use_flake() {
        _orig_use_flake "$@"
        unset IN_NIX_SHELL
      }
    '';
  };
}
