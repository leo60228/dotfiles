{ small ? false, deviceScaleFactor ? 1 }:
{ pkgs, config, lib, ... }:

#let gmusicproxy = pkgs.callPackage ./gmusicproxy.nix {};
{
  home.stateVersion = "21.05";

  home.packages = with pkgs; if small then [
    libwebp
    ripgrep
    (callPackage ./neovim {})
    zip
    pciutils
    lftp
    bat
    nodejs_latest
    nix-prefetch-git
    ffmpeg
    gnupg
    pkgconfig
    gist
    gitAndTools.hub
    p7zip
    file
    unzip
    usbutils
    gnumake
    (hiPrio gcc)
    (pkgs.hiPrio (callPackage ./bin.nix {}))
  ] else [
    clang-tools
    prusa-slicer
    bitwarden
    bitwarden-cli
    (callPackage ./cargo-sync-readme.nix {})
    cargo-expand
    cargo-edit
    qbittorrent
    libwebp
    nix-prefetch-github
    element-desktop
    libnotify
    escrotum
    (let rust = (callPackage ./rust.nix {}).rust; in (ripgrep.override {
      rustPlatform = makeRustPlatform {
        cargo = rust;
        rustc = rust;
      };
    }).overrideAttrs (oldAttrs: {
      #buildPhase = builtins.replaceStrings ["pcre2"] ["'pcre2 simd-accel'"] oldAttrs.buildPhase;
    }))
    linuxPackages.perf
    zip
    glxinfo
    efibootmgr
    slop
    jq
    mosquitto
    #(callPackage ./nnasos.nix {})
    rclone
    (hiPrio rustup)
    pciutils
    lftp
    google-play-music-desktop-player
    dolphinEmuMaster
    #(callPackage ./kflash.py {})
    alsaLib
    alsaLib.dev
    (callPackage ./twili-gdb.nix {})
    (lib.setPrio (-100) llvmPackages_8.clang)
    llvmPackages_8.llvm
    (callPackage ./zenstates.nix {})
    #(callPackage ./unityenv.nix {})
    easytag
    cantata
    calibre
    #(import <unstable> {}).xpra
    go-bindata
    xdotool
    dbus
    dbus.lib
    dbus.dev
    gnome3.zenity
    gnuplot
    #(callPackage ./amdgpu-utils {})
    bat
    nodejs_latest
    jetbrains.rider
    (androidenv.composeAndroidPackages { includeNDK = true; ndkVersion = "22.1.7171670"; }).ndk-bundle
    openssl.out
    openssl.dev
    carnix
    nix-prefetch-git
    pandoc
    (callPackage ./twib.nix {})
    (makeDesktopItem rec {
      name = "nintendo_switch";
      exec = "switch";
      icon = ./files/switch.svg;
      desktopName = "Nintendo Switch";
      genericName = desktopName;
    })
    (writeShellScriptBin "windows" ''
      sudo virsh start win10 || true
      until [ -e /dev/shm/looking-glass ]; do
        sleep 1
      done
      ${scream}/bin/scream -i virbr0 &
      ${pkgs.looking-glass-client}/bin/looking-glass-client -F &
      wait -n
      pkill -P $$
      ''
    )
    (makeDesktopItem rec {
      name = "windows10";
      exec = "windows";
      icon = ./files/windows.svg;
      desktopName = "Windows 10";
      genericName = desktopName;
      categories = "System;Utility;";
    })
    (callPackage ./discord.nix { inherit deviceScaleFactor; })
    (hiPrio gtk2)
    (lowPrio llvmPackages.clang-unwrapped)
    SDL
    SDL2
    atk
    atk.dev
    (pkgs.writeShellScriptBin "audacity" ''
    exec env PULSE_LATENCY_MSEC=30 ${audacity}/bin/audacity "$@"
    '')
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
    (callPackage ./rust.nix {}).rust
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
    steam-run
    xclip
    xsel
    gimp
    symbola
    kitty
    (python38.withPackages (ps: with ps; [ pyusb neovim pillow cryptography pip setuptools ]))
    #vlc
    #(libsForQt514.callPackage ./vlc-4.nix {})
    (libsForQt514.callPackage ./vlc.nix {})
    multimc
    (callPackage ./neovim {})
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
    #qemu
    gitAndTools.git-annex
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
    dotnet-sdk_5
    #gmusicproxy
    mono5
    #julia_06
    (pkgs.hiPrio (callPackage ./bin.nix {}))
    (callPackage ./fuseenano.nix {})
    (python27.withPackages (ps: with ps; [ neovim ]))
    #(import ./julia-oldpkgs.nix {version = "06";})
    #(import ./julia-oldpkgs.nix {version = "07";})
    #(import ./julia-oldpkgs.nix {version = "11";})
    (callPackage ./twemoji-svg.nix {})
    (callPackage ./twemoji-colr.nix {})
    syncthingtray
  ];

  programs.git = {
    enable = true;
    package = if small then pkgs.git else pkgs.gitAndTools.gitFull;
    userName = "leo60228";
    userEmail = "leo@60228.dev";
    extraConfig.init.defaultBranch = "main";
  };

  programs.firefox = {
    enable = !small;
    package = (import ./firefox.nix pkgs.lib).overrideAttrs (oldAttrs: {
      passthru.browserName = "firefox";
    });
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [ darkreader old-reddit-redirect reddit-enhancement-suite stylus greasemonkey ublock-origin ];
    profiles.default = {
      settings = {
        "dom.allow_scripts_to_close_windows" = true;
        "dom.webgpu.enabled" = true;
        "gfx.webrender.all" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "startup.homepage_welcome_url" = "about:newtab";
        "datareporting.policy.firstRunURL" = "";
        "browser.uiCustomization.state" = builtins.toJSON {
          currentVersion = 16;
          placements = {
            PersonalToolbar = [ "personal-bookmarks" ];
            TabsToolbar = [ "tabbrowser-tabs" "new-tab-button" "alltabs-button" ];
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "home-button"
              "urlbar-container"
              "downloads-button"
              "library-button"
              "sidebar-button"
              "fxa-toolbar-menu-button"
              "addon_darkreader_org-browser-action"
              "ublock0_raymondhill_net-browser-action"
            ];
            toolbar-menubar = [ "menubar-items" ];
            widget-overflow-fixed-list = [
              "_e4a8a97b-f2ed-450b-b12d-ee082ba24781_-browser-action"
              "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
            ];
          };
        };
      };
    };
  };

  programs.go.enable = !small;

  services.gpg-agent = {
    enable = true;
    # enableSshSupport = true;
    enableExtraSocket = true;
    grabKeyboardAndMouse = false;
  };

  programs.home-manager.enable = true;
  #programs.home-manager.path = /home/leo60228/home-manager;

  systemd.user.startServices = true;

  #systemd.user.services.gmusicproxy = lib.mkIf (!small) {
  #  Unit = {
  #    Description = "play music proxy";
  #    After = [ "network-online.target" ];
  #  };

  #  Service = {
  #    Type = "simple";
  #    ExecStart = "${gmusicproxy}/bin/gmusicproxy";
  #    Restart = "always";
  #  };

  #  Install = {
  #    WantedBy = [ "network-online.target" ];
  #  };
  #};

  xdg.configFile."systemd/user/app-discord-.scope.d/override.conf".text = ''
  [Unit]
  Wants=mpdiscord.service
  '';

  systemd.user.services.mpdiscord = lib.mkIf (!small) {
    Unit = {
      Description = "mpdiscord";
      BindsTo = [ "mpd.service" ];
      After = [ "mpd.service" ];
    };

    Service = {
      ExecStart = "${pkgs.mpdiscord}/bin/mpdiscord /home/leo60228/.config/mpdiscord.toml";
    };
  };

  systemd.user.services.scream-receiver = {
    Unit = {
      BindsTo = [ "pipewire-pulse.socket" ];
      After = [ "pipewire-pulse.socket" ];
    };

    Service = {
      ExecStart = "${pkgs.scream}/bin/scream -i virbr0";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  systemd.user.services.twibd = lib.mkIf (!small) {
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

  systemd.user.sockets.twibd = lib.mkIf (!small) {
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
  programs.bash.bashrcExtra = ''
  [ -z "$QT_SCREEN_SCALE_FACTORS" ] && [ ! -z "$_QT_SCREEN_SCALE_FACTORS" ] && export QT_SCREEN_SCALE_FACTORS="$_QT_SCREEN_SCALE_FACTORS"
  export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/.bin/:$PATH:$HOME/.nix-profile/bin/:$HOME/.cargo/bin:$HOME/.dotnet/tools:$HOME/NDK/arm/bin:/run/current-system/sw/bin"
  export PATH="$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')"
  export PYTHONPATH="$(python3 -c 'print(__import__("site").USER_SITE)')''${PYTHONPATH:+:}"
  export PYTHONPATH="$(printf "%s" "$PYTHONPATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')"
  '';
  programs.bash.initExtra = ''
    export PS1=\\n\\\[\\033\[?1l\\\[\\033\[1\;32m\\\]\[\\\[\\e\]0\;leo60228@leoservices:\ \\w\\a\\\]\\u@\\h:\\w\]\\\$\\\[\\033\[0m\\\]\ 

    [[ $- != *i* ]] && return

    export EDITOR=vim

    export NIX_REMOTE=daemon

    . ${./files/dotnet-suggest-shim.bash}

    . $HOME/.credentials >& /dev/null || true

    eval $(hub alias -s)

    if [ -z "$NEOFETCH_RAN" ]; then
        neofetch --config ${./files/neofetch.conf}
        export NEOFETCH_RAN=1
    fi
  '';

  home.sessionVariables = {
    EDITOR = "vim";
    RUSTFMT = "rustfmt";
    CFLAGS_armv7_linux_androideabi = "-I/home/leo60228/NDK/arm/sysroot/usr/include/ -L/home/leo60228/NDK/arm/sysroot/usr/lib -L/home/leo60228/NDK/arm/arm-linux-androideabi/lib/armv7-a/ -D__ANDROID_API__=26";
    TWIB_UNIX_FRONTEND_PATH = "/run/user/1000/twibd.sock";
    LIBRARY_PATH = "/home/leo60228/.nix-profile/lib";
    PKG_CONFIG_PATH = "/home/leo60228/.nix-profile/lib/pkgconfig:/home/leo60228/.nix-profile/share/pkgconfig";
    BAT_THEME = "Solarized";
  } // (if small then {} else {
    CPATH = "/home/leo60228/.nix-profile/include:${pkgs.gtk3.dev}/include/gtk-3.0:${pkgs.glib.out}/lib/glib-2.0/include:${pkgs.glib.dev}/include/glib-2.0:${pkgs.pango.dev}/include/pango-1.0:${pkgs.cairo.dev}/include/cairo:${pkgs.gdk_pixbuf.dev}/include/gdk-pixbuf-2.0:${pkgs.atk.dev}/include/atk-1.0";
    LIBCLANG_PATH = "${pkgs.llvmPackages.clang-unwrapped.lib}/lib";
    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_5}";
  });

  programs.bash.shellAliases."xargo-nx" =
    ''docker run --rm -it -v "$(pwd):/workdir" '' +
    ''-v "/run/user/1000/twibd.sock:/var/run/twibd.sock" '' +
    ''-v "/home/leo60228/.cargo/git/:/root/.cargo/git/" '' +
    ''-v "/home/leo60228/.cargo/registry/:/root/.cargo/registry/" '' +
    ''rustyhorizon/docker:latest xargo'';

  programs.bash.shellAliases.cat = "bat";

  programs.bash.shellAliases."nixos-rebuild" = "nixos-rebuild -L";
  programs.bash.shellAliases.sudo = "sudo ";

  xdg.configFile."kitty/kitty.conf".text = ''
    remember_window_size no
    initial_window_width 1700
    initial_window_height 1100
  '';

  xdg.configFile."bat/themes/Solarized.tmTheme".source = ./Solarized.tmtheme;

  home.file.".mrconfig".source = ./mrconfig;

  home.file.".inputrc".text = ''
  $include /etc/inputrc
  "\e[A":history-search-backward
  "\e[B":history-search-forward
  set enable-bracketed-paste on
  '';

  home.file.".tmux.conf".text = ''
    set -g mouse on
    set-window-option -g mode-keys vi
    bind -Tcopy-mode-vi MouseDragEnd1Pane send -X copy-pipe "xsel -ib" \; display-message 'Copied to system clipboard' \; send Escape

  # Colors
    set -g default-terminal "tmux-256color"
    set -ga terminal-overrides ",*256col*:Tc"

  # Misc
    set-option -sg escape-time 10
  '';

  home.file.".frei0r-1/lib" = lib.mkIf (!small) {
    source = "${pkgs.frei0r}/lib/frei0r-1";
    recursive = true;
  };

  home.file.".terminfo".source = ./files/terminfo;
  home.file.".terminfo".recursive = true;

  home.file.".rustup/toolchains/system" = lib.mkIf (!small) {
    source = (pkgs.callPackage ./rust.nix {}).rust;
  };

  home.file.".XCompose".source = ./files/XCompose;

  services.mpd = {
    enable = !small;
    extraConfig = ''
        audio_output {
            type    "pulse"
            name    "My Pulse Output"
        }
        playlist_directory "~/Playlists"
    '';
    network.listenAddress = "0.0.0.0";
  };

  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  xdg.configFile."openbox" = {
    source = ./files/openbox;
    recursive = true;
  };

  xdg.configFile."opensnap" = {
    source = ./files/opensnap;
    recursive = true;
  };

  home.file.".themes" = {
    source = ./files/openbox-themes;
    recursive = true;
  };

  fonts.fontconfig.enable = lib.mkForce true;
  #fonts.fontconfig.enable = true;
  #fonts.fontconfig.aliases = [{
  #  families = [ "Hack" ];
  #  default = [ "monospace" ];
  #}];
  #fonts.fontconfig.matches = [{
  #  tests = [
  #    {
  #      compare = "eq";
  #      name = "family";
  #      exprs = [ "sans-serif" ];
  #    }
  #    {
  #      compare = "eq";
  #      name = "family";
  #      exprs = [ "monospace" ];
  #    }
  #  ];
  #  edits = [{
  #    mode = "delete";
  #    name = "family";
  #  }];
  #}];

  programs.vscode = lib.mkIf (!small) {
    enable = true;
    package = pkgs.callPackage ./vscode-fhs.nix {};
    userSettings = {
      "omnisharp.path" = "${pkgs.omnisharp-roslyn}/bin/omnisharp";
      "workbench.colorTheme" = "Solarized Dark";
      "telemetry.enableTelemetry" = false;
    };
    extensions = (with pkgs.vscode-extensions; [
      bbenoist.Nix
      vscodevim.vim
    ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "csharp";
        publisher = "ms-dotnettools";
        version = "1.23.6";
        sha256 = "0dc0krp5z8ayk59jhm1n91lldwgr7a8f6al8h5m75kl7q4ib7rlk";
      }
    ];
  };

  home.file.".vscode/extensions/ms-dotnettools.csharp" = lib.mkIf (!small) {
    recursive = true;
  };

  home.file.".omnisharp/omnisharp.json" = lib.mkIf (!small) {
    text = builtins.toJSON {
      MsBuild.UseLegacySdkResolver = true;
    };
  };

  home.file.".vimspector/gadgets/linux/.gadgets.d/hm.json" = lib.mkIf (!small) {
    text = builtins.toJSON {
      adapters = {
        netcoredbg = {
          name = "netcoredbg";
          command = [ "${pkgs.callPackage ./netcoredbg {}}/netcoredbg" "--interpreter=vscode" ];
          attach = {
            pidProperty = "processId";
            pidSelect = "ask";
          };
          configuration = {
            cwd = "\${workspaceRoot}";
          };
        };
      };
    };
  };

  home.file.".gradle/gradle.properties".text = lib.mkIf (!small) ''
    org.gradle.java.installations.paths=${pkgs.graalvm17-ee},${pkgs.jdk8}
    org.gradle.java.installations.auto-download=false
  '';

  services.syncthing = lib.mkIf (!small) {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };

  xdg.configFile."hm_kglobalshortcutsrc".source = ./files/hm_kglobalshortcutsrc;
  xdg.configFile."khotkeysrc".source = ./files/khotkeysrc;

  home.activation.kconf = lib.hm.dag.entryAfter ["linkGeneration"] ''
  $DRY_RUN_CMD ${pkgs.plasma5Packages.kconfig.out}/libexec/kf5/kconf_update ${VERBOSE:+--debug} "${./files/kconf.upd}"
  $DRY_RUN_CMD ${pkgs.qt5.qttools.bin}/bin/qdbus org.kde.kded5 /modules/khotkeys reread_configuration || true
  '';
}
