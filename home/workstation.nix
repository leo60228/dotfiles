{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.vris.workstation {
  home.packages = with pkgs; [
    archipelago
    nix-eval-jobs
    fzf
    pnpm
    unixtools.xxd
    (python3.pkgs.toPythonApplication (
      python3.pkgs.beets.override {
        pluginOverrides = {
          #filetote = {
          #  enable = true;
          #  propagatedBuildInputs = [ beetsPackages.filetote ];
          #};
          bandcamp = {
            enable = true;
            propagatedBuildInputs = [ leoPkgs.beetcamp ];
          };
        };
      }
    ))
    opusTools
    docker-credential-helpers
    libsecret
    parsec-bin
    wiimms-iso-tools
    leoPkgs.hactoolnet
    colmena
    fusee-nano
    obs-studio
    ares
    (mesen.overrideAttrs (oldAttrs: {
      dotnetRuntimeDeps = oldAttrs.dotnetRuntimeDeps ++ [
        xorg.libXrandr
        xorg.libXcursor
      ];
    }))
    ryubing
    ctrtool
    hactool
    qpwgraph
    jetbrains-toolbox
    rsgain
    kio-fuse
    lab
    bitwarden-cli
    cargo-edit
    qbittorrent
    nix-prefetch-github
    element-desktop
    mosquitto
    rclone
    (lib.hiPrio rustup)
    lftp
    dolphin-emu
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
    hub
    prismlauncher
    mcpelauncher-ui-qt
    #mgba
    wineWowPackages.staging
    gnumake
    (lib.hiPrio gcc)
    hplip
    dotnet-sdk
    mono
    vscode-fhs
    yubikey-touch-detector
    basedpyright
    typescript-language-server
    vscode-langservers-extracted
    ruff
    nixfmt
    nil
    lua-language-server
    stylua
    nerd-fonts.hack
  ];

  xdg.configFile."systemd/user/app-archipelago@.service.d/override.conf".text = ''
    [Service]
    Environment=KIVY_METRICS_DENSITY=2
  '';

  programs.git.package = pkgs.gitFull;
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

  programs.mangohud = {
    enable = true;
    settings.no_display = true;
  };

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
}
