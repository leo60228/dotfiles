{
  small ? false,
  deviceScaleFactor ? 1,
}:
{
  pkgs,
  config,
  lib,
  ...
}:

#let gmusicproxy = pkgs.callPackage ./gmusicproxy.nix {};
{
  home.stateVersion = "21.05";

  home.packages =
    with pkgs;
    if small then
      [
        leoPkgs.hyfetch
        libwebp
        ripgrep
        (callPackage ./neovim { })
        zip
        pciutils
        lftp
        bat
        nodejs_latest
        nix-prefetch-git
        ffmpeg
        gnupg
        pkg-config
        gist
        gitAndTools.hub
        p7zip
        file
        unzip
        usbutils
        gnumake
        (hiPrio gcc)
        leoPkgs.bin
      ]
    else
      [
        parsec-bin
        leoPkgs.redumper
        wiimms-iso-tools
        leoPkgs.hactoolnet
        gh
        license-cli
        signal-desktop
        colmena
        fusee-nano
        obs-studio
        thunderbird
        gamescope
        lutris
        pkgsCross.avr.stdenv.cc
        avrdude
        bloom
        platformio
        ares
        leoPkgs.citra
        ryujinx
        ctrtool
        hactool
        pdm
        leoPkgs.hyfetch
        libsForQt5.kdelibs4support
        qpwgraph
        htop
        #pokefinder
        leoPkgs.eontimer
        jetbrains-toolbox
        rsgain
        imagemagick
        kio-fuse
        coursier
        alsaUtils
        gitAndTools.lab
        clang-tools
        prusa-slicer
        bitwarden
        bitwarden-cli
        cargo-sync-readme
        cargo-expand
        cargo-edit
        qbittorrent
        libwebp
        nix-prefetch-github
        element-desktop
        libnotify
        escrotum
        ripgrep
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
        dolphinEmuMaster
        #(callPackage ./kflash.py {})
        alsaLib
        alsaLib.dev
        gdb
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
        zenity
        gnuplot
        #(callPackage ./amdgpu-utils {})
        bat
        nodejs_latest
        (androidenv.composeAndroidPackages {
          includeNDK = true;
          ndkVersion = "22.1.7171670";
        }).ndk-bundle
        openssl.out
        openssl.dev
        nix-prefetch-git
        pandoc
        (leoPkgs.discord.override { inherit deviceScaleFactor; })
        vesktop
        (hiPrio gtk2)
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
        gdk-pixbuf.dev
        gdk-pixbuf
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
        grim
        slurp
        mpv
        pango
        pango.dev
        pango.out
        pkg-config
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
        yt-dlp
        leoPkgs.rust.rust
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
        wl-clipboard
        gimp
        kitty
        (python311.withPackages (
          ps: with ps; [
            pyusb
            neovim
            pillow
            cryptography
            pip
            setuptools
          ]
        ))
        vlc
        #(libsForQt514.callPackage ./vlc-4.nix {})
        #(libsForQt514.callPackage ./vlc.nix {})
        prismlauncher
        (callPackage ./neovim { })
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
        (
          with dotnetCorePackages;
          combinePackages [
            sdk_6_0
            sdk_7_0
          ]
        )
        #gmusicproxy
        mono5
        #julia_06
        leoPkgs.bin
        #(import ./julia-oldpkgs.nix {version = "06";})
        #(import ./julia-oldpkgs.nix {version = "07";})
        #(import ./julia-oldpkgs.nix {version = "11";})
        syncthingtray
        leoPkgs.twemoji-ttf
        leoPkgs.determination-fonts
      ];

  programs.git = {
    enable = true;
    package = if small then pkgs.git else pkgs.gitAndTools.gitFull;
    userName = "leo60228";
    userEmail = "leo@60228.dev";
    extraConfig.init.defaultBranch = "main";
    extraConfig.hub.protocol = "ssh";
  };

  programs.go.enable = !small;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    grabKeyboardAndMouse = false;
    pinentryPackage = pkgs.pinentry-qt;
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

  systemd.user.services.kio-fuse = lib.mkIf (!small) {
    Unit = {
      Description = "Fuse interface for KIO";
      PartOf = "graphical-session.target";
    };

    Service = {
      ExecStart = "${pkgs.kio-fuse}/libexec/kio-fuse -f";
      BusName = "org.kde.KIOFuse";
      Slice = "background.slice";
    };
  };

  xdg.configFile."systemd/user/app-vesktop@.service.d/override.conf".text = ''
    [Unit]
    Wants=mpdiscord.service
  '';

  systemd.user.services.mpdiscord = lib.mkIf (!small) {
    Unit = {
      Description = "mpdiscord";
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

  programs.bash.enable = true;
  programs.bash.bashrcExtra =
    ''
      [ -z "$QT_SCREEN_SCALE_FACTORS" ] && [ ! -z "$_QT_SCREEN_SCALE_FACTORS" ] && export QT_SCREEN_SCALE_FACTORS="$_QT_SCREEN_SCALE_FACTORS"
      export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.npm-global/bin:$HOME/.bin/:$PATH:$HOME/.nix-profile/bin/:$HOME/.cargo/bin:$HOME/.dotnet/tools:$HOME/NDK/arm/bin:/run/current-system/sw/bin"
      export PATH="$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')"
    ''
    + lib.optionalString (!small) ''
      export PYTHONPATH="$(python3 -c 'print(__import__("site").USER_SITE)')''${PYTHONPATH:+:}"
      export PYTHONPATH="$(printf "%s" "$PYTHONPATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')"
    '';
  programs.bash.initExtra = ''
    export PS1=\\n\\\[\\033\[?1l\\\[\\033\[1\;32m\\\]\[\\\[\\e\]0\;leo60228@leoservices:\ \\w\\a\\\]\\u@\\h:\\w\]\\\$\\\[\\033\[0m\\\]\ 

    [[ $- != *i* ]] && return

    export EDITOR=vim

    export NIX_REMOTE=daemon

    . $HOME/.credentials >& /dev/null || true

    eval $(hub alias -s)

    if [ -z "$NEOFETCH_RAN" ]; then
        neowofetch --config ${./files/neofetch.conf}
        export NEOFETCH_RAN=1
    fi
  '';

  home.sessionVariables =
    {
      EDITOR = "vim";
      RUSTFMT = "rustfmt";
      CFLAGS_armv7_linux_androideabi = "-I/home/leo60228/NDK/arm/sysroot/usr/include/ -L/home/leo60228/NDK/arm/sysroot/usr/lib -L/home/leo60228/NDK/arm/arm-linux-androideabi/lib/armv7-a/ -D__ANDROID_API__=26";
      LIBRARY_PATH = "/home/leo60228/.nix-profile/lib";
      PKG_CONFIG_PATH = "/home/leo60228/.nix-profile/lib/pkgconfig:/home/leo60228/.nix-profile/share/pkgconfig";
      BAT_THEME = "Solarized (dark)";
    }
    // (
      if small then
        { }
      else
        {
          CPATH = "/home/leo60228/.nix-profile/include:${pkgs.gtk3.dev}/include/gtk-3.0:${pkgs.glib.out}/lib/glib-2.0/include:${pkgs.glib.dev}/include/glib-2.0:${pkgs.pango.dev}/include/pango-1.0:${pkgs.cairo.dev}/include/cairo:${pkgs.gdk-pixbuf.dev}/include/gdk-pixbuf-2.0:${pkgs.atk.dev}/include/atk-1.0";
          OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
          OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
        }
    );

  programs.bash.shellAliases."xargo-nx" =
    ''docker run --rm -it -v "$(pwd):/workdir" ''
    + ''-v "/home/leo60228/.cargo/git/:/root/.cargo/git/" ''
    + ''-v "/home/leo60228/.cargo/registry/:/root/.cargo/registry/" ''
    + ''rustyhorizon/docker:latest xargo'';

  programs.bash.shellAliases.cat = "bat";

  programs.bash.shellAliases."nixos-rebuild" = "nixos-rebuild -L";
  programs.bash.shellAliases.sudo = "sudo ";

  xdg.configFile."kitty/kitty.conf".text = ''
    remember_window_size no
    initial_window_width 1700
    initial_window_height 1100
  '';

  xdg.configFile."bat/themes/Solarized.tmTheme".source = ./files/Solarized.tmtheme;

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

  home.file.".rustup/toolchains/system" = lib.mkIf (!small) { source = pkgs.leoPkgs.rust.rust; };

  home.file.".XCompose".source = ./files/XCompose;

  xdg.configFile."nixpkgs/config.nix".source = ./files/nixpkgs-config.nix;

  xdg.configFile."openbox" = {
    source = ./files/openbox;
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
    package = pkgs.leoPkgs.vscode-fhs;
    userSettings = {
      "omnisharp.path" = "${pkgs.omnisharp-roslyn}/bin/omnisharp";
      "workbench.colorTheme" = "Solarized Dark";
      "telemetry.enableTelemetry" = false;
    };
    extensions =
      (with pkgs.vscode-extensions; [
        bbenoist.nix
        vscodevim.vim
      ])
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "csharp";
          publisher = "ms-dotnettools";
          version = "1.23.6";
          sha256 = "0dc0krp5z8ayk59jhm1n91lldwgr7a8f6al8h5m75kl7q4ib7rlk";
        }
      ];
  };

  home.file.".vscode/extensions/ms-dotnettools.csharp" = lib.mkIf (!small) { recursive = true; };

  home.file.".omnisharp/omnisharp.json" = lib.mkIf (!small) {
    text = builtins.toJSON { MsBuild.UseLegacySdkResolver = true; };
  };

  home.file.".gradle/gradle.properties" = lib.mkIf (!small) {
    text = ''
      org.gradle.java.installations.paths=${pkgs.temurin-bin-8}
      org.gradle.java.installations.auto-download=false
    '';
  };

  home.file.".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.plasma5Packages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  services.syncthing = lib.mkIf (!small) { enable = true; };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  xdg.configFile."hm_kglobalshortcutsrc".source = ./files/hm_kglobalshortcutsrc;
  xdg.configFile."khotkeysrc".source = ./files/khotkeysrc;

  home.activation.kconf = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    $DRY_RUN_CMD ${pkgs.plasma5Packages.kconfig.out}/libexec/kf5/kconf_update ${"VERBOSE:+--debug"} "${./files/kconf.upd}"
    $DRY_RUN_CMD ${pkgs.qt5.qttools.bin}/bin/qdbus org.kde.kded5 /modules/khotkeys reread_configuration || true
  '';

  programs.firefox = {
    enable = true;
    policies = {
      OverrideFirstRunPage = "about:newtab";
      EnableTrackingProtection.Value = true;
      PasswordManagerEnabled = false;
    };
    profiles.default = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        darkreader
        old-reddit-redirect
        reddit-enhancement-suite
        stylus
        greasemonkey
        ublock-origin
        bitwarden
        plasma-integration
      ];
      settings = {
        "extensions.autoDisableScopes" = 0;
        "dom.allow_scripts_to_close_windows" = true;
        "dom.webgpu.enabled" = true;
        "gfx.webrender.all" = true;
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "datareporting.policy.firstRunURL" = "";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.uiCustomization.state" = {
          currentVersion = 18;
          placements = {
            PersonalToolbar = [ "personal-bookmarks" ];
            TabsToolbar = [
              "tabbrowser-tabs"
              "new-tab-button"
              "alltabs-button"
            ];
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
              "_testpilot-containers-browser-action"
              "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
            ];
            toolbar-menubar = [ "menubar-items" ];
            unified-extensions-area = [ ];
            widget-overflow-fixed-list = [
              "_e4a8a97b-f2ed-450b-b12d-ee082ba24781_-browser-action"
              "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
              "firefox-view-button"
            ];
          };
          seen = [
            "save-to-pocket-button"
            "_d133e097-46d9-4ecc-9903-fa6a722a6e0e_-browser-action"
            "_testpilot-containers-browser-action"
            "addon_darkreader_org-browser-action"
            "plasma-browser-integration_kde_org-browser-action"
            "sponsorblocker_ajay_app-browser-action"
            "ublock0_raymondhill_net-browser-action"
            "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action"
            "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"
            "_e4a8a97b-f2ed-450b-b12d-ee082ba24781_-browser-action"
            "developer-button"
          ];
        };
      };
      userChrome = ''
        #tabbrowser-tabs:not([overflow="true"]) ~ #alltabs-button {
          display: none !important;
        }
      '';
    };
  };
}
