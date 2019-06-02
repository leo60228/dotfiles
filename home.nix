{ pkgs, config, ... }:

let gmusicproxy = pkgs.callPackage ./gmusicproxy.nix {};
in {
  home.packages = with pkgs; [
    easytag
    cantata
    calibre
    (import <unstable> {}).xpra
    go-bindata
    nodejs
    xdotool
    dbus
    dbus.lib
    dbus.dev
    gnome3.zenity
    gnuplot
    androidenv.androidPkgs_9_0.ndk-bundle
    openssl.out
    openssl.dev
    carnix
    nix-prefetch-git
    pandoc
    firefox
    (callPackage ./twib.nix {})
    (makeDesktopItem rec {
      name = "nintendo_switch";
      exec = "switch";
      icon = ./files/switch.svg;
      desktopName = "Nintendo Switch";
      genericName = desktopName;
      categories = "Games;";
    })
    (hiPrio gtk2)
    (lowPrio llvmPackages_39.clang-unwrapped)
    SDL
    SDL2
    atk
    atk.dev
    audacity
    boost
    cairo
    cairo.dev
    cmake
    curl.dev
    desktop-file-utils
    ffmpeg
    gdk_pixbuf
    gdk_pixbuf.dev
    glib
    glib.dev
    glib.out
    gnupg
    gtk3
    gtk3.dev
    gtk3.out
    libGL
    libao
    libopus
    lua5_2
    maim
    mpv
    pango
    pango.dev
    pango.out
    pkgconfig
    portaudio
    xorg.libX11
    xorg.libX11.dev
    xorg.libXtst
    xorg.libXcursor
    xorg.libXcursor.dev
    xorg.libXi
    xorg.libXi.dev
    xorg.libXrandr
    xorg.libXrandr.dev
    xorg.libxcb
    xorg.libxcb.dev
    xorg.xorgproto
    youtube-dl
    (rustChannelOfTargets "nightly" "2019-06-02" [
        "x86_64-unknown-linux-gnu"
        "arm-linux-androideabi"
    ])
    libreoffice
    tmux
    screen
    irssi
    rclone
    gist
    gitAndTools.hub
    appimage-run
    p7zip
    #gimpPlugins.gap
    steam-run-native
    vscode
    discord
    xclip
    xsel
    gimp
    google-musicmanager
    symbola
    kitty
    (python36.withPackages (ps: with ps; [ pyusb neovim ]))
    #(obs-studio.override {
    #  ffmpeg = ffmpeg-full.override {
    #    inherit nvidia-video-sdk;
    #    nvenc = true;
    #    nonfreeLicensing = true;
    #  };
    #})
    #frei0r
    #(ffmpeg-full.override {
    #  inherit nvidia-video-sdk;
    #  nvenc = true;
    #  nonfreeLicensing = true;
    #})
    #kdeApplications.kdenlive
    vlc
    multimc
    #dolphinEmuMaster
    openalSoft
    multimc
    (callPackage ./neovim {
      vimPlugins = (import <unstable> {}).vimPlugins;
    })
    openscad
    dpkg
    (lib.setPrio (-20) binutils-unwrapped)
    #slic3r-prusa3d
    sdcc
    mgba
    filezilla
    nasm
    grub2
    xorriso
    qemu
    gitAndTools.git-annex
    gitAndTools.gitFull
    mr
    stow
    file
    gpx
    pciutils
    unzip
    tigervnc
    usbutils
    #dotnetPackages.Nuget
    wineWowPackages.unstable
    gnumake
    (hiPrio gcc)
    meteor
    hplip
    virtualbox
    dotnet-sdk
    gmusicproxy
    mono5
    #julia_06
    (pkgs.hiPrio (callPackage ./bin.nix {}))
    (callPackage ./fuseenano.nix {})
    (python27.withPackages (ps: with ps; [ neovim ]))
    (import ./julia-oldpkgs.nix {version = "06";})
    (import ./julia-oldpkgs.nix {version = "07";})
    (import ./julia-oldpkgs.nix {version = "11";})
  ];

  programs.go.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    grabKeyboardAndMouse = false;
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

  systemd.user.startServices = true;

  systemd.user.services.gmusicproxy = {
    Unit = {
      Description = "play music proxy";
      After = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${gmusicproxy}/bin/gmusicproxy";
      Restart = "always";
    };

    Install = {
      WantedBy = [ "network-online.target" ];
    };
  };

  systemd.user.services.twibd = {
    Unit = {
      Description = "Twili Bridge Daemon";
      Requires = [ "twibd.socket" ];
    };

    Service = {
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "${pkgs.callPackage ./twib.nix {}}/bin/twibd --systemd";
      StandardError = "journal";
    };
  };

  systemd.user.sockets.twibd = {
    Unit = {
      Description = "Twili Bridge Daemon";
    };

    Socket = {
      ListenStream = "/run/user/1000/twibd.sock";
      ListenMode = "0666";
      Accept = "no";
    };

    Install = {
      WantedBy = [ "sockets.target" ];
    };
  };

  programs.bash.enable = true;
  programs.bash.initExtra = ''
    [[ $- != *i* ]] && return

    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] ; then
      exec tmux -u -2
    fi

    export PATH="$HOME/.bin/:$PATH:$HOME/.cargo/bin:${pkgs.androidenv.androidPkgs_9_0.ndk-bundle}/libexec/android-sdk/ndk-bundle/"
    export EDITOR=vim

    export NIX_REMOTE=daemon

    eval $(hub alias -s)
  '';

  programs.bash.sessionVariables = {
    EDITOR = "vim";
    TWIB_UNIX_FRONTEND_PATH = "/run/user/1000/twibd.sock";
    LIBRARY_PATH = "/home/leo60228/.nix-profile/lib";
    PKG_CONFIG_PATH = "/home/leo60228/.nix-profile/lib/pkgconfig:/home/leo60228/.nix-profile/share/pkgconfig";
    CPATH = "/home/leo60228/.nix-profile/include:${pkgs.gtk3.dev}/include/gtk-3.0:${pkgs.glib.out}/lib/glib-2.0/include:${pkgs.glib.dev}/include/glib-2.0:${pkgs.pango.dev}/include/pango-1.0:${pkgs.cairo.dev}/include/cairo:${pkgs.gdk_pixbuf.dev}/include/gdk-pixbuf-2.0:${pkgs.atk.dev}/include/atk-1.0";
    LIBCLANG_PATH = "${pkgs.llvmPackages_39.clang-unwrapped.lib}/lib";
    OPENSSL_DIR = "/home/leo60228/.nix-profile";
  };

  programs.bash.shellAliases."xargo-nx" =
    ''docker run --rm -it -v "$(pwd):/workdir" '' +
    ''-v "/run/user/1000/twibd.sock:/var/run/twibd.sock" '' +
    ''-v "/home/leo60228/.cargo/git/:/root/.cargo/git/" '' +
    ''-v "/home/leo60228/.cargo/registry/:/root/.cargo/registry/" '' +
    ''rustyhorizon/docker:latest xargo'';

    xdg.configFile."kitty/kitty.conf".text = ''
      remember_window_size no
      initial_window_width 1700
      initial_window_height 1100
    '';

    home.file.".mrconfig".source = ./mrconfig;

    home.file.".tmux.conf".text = ''
      set -g mouse on
      set-window-option -g mode-keys vi
      bind -Tcopy-mode-vi MouseDragEnd1Pane send -X copy-pipe "xsel -ib" \; display-message 'Copied to system clipboard' \; send Escape

    # Plugins
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'

    # Colors
      if-shell -b '[[ "$TERM" == "xterm-256color" ]]' " \
      set -s default-terminal \"xterm-256color\" \
      set-option -sa terminal-overrides \",xterm-256color:Tc\" "
      if-shell -b '[[ "$TERM" != "xterm-256color" ]]' " \
      set -s default-terminal \"xterm-256color\" \
      set-environment -g TMUX_FORCE_NO_TRUECOLOR 1 "
    # Misc
      set-option -sg escape-time 10
    '';

    home.file.".frei0r-1/lib".source = "${pkgs.frei0r}/lib/frei0r-1";
    home.file.".frei0r-1/lib".recursive = true;

    home.file.".terminfo".source = ./files/terminfo;
    home.file.".terminfo".recursive = true;

    xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

    home.activation.kbuildsycoca5 = config.lib.dag.entryAfter ["linkGeneration"] "$DRY_RUN_CMD kbuildsycoca5";
    home.activation.startSockets = config.lib.dag.entryAfter ["reloadSystemD"] ''
      $DRY_RUN_CMD env XDG_RUNTIME_DIR=/run/user/1000 systemctl --user start sockets.target
    ''; # dirty hack

    nixpkgs.overlays = map (e: import (./nixpkgs + ("/" + e))) (builtins.attrNames (builtins.readDir ./nixpkgs));
    nixpkgs.config.allowUnfree = true;

    services.mpd = {
        enable = true;
        extraConfig = ''
            audio_output {
                type    "pulse"
                name    "My Pulse Output"
            }
        '';
    };
  }
