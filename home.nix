{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./home/graphical.nix
    ./home/workstation.nix
  ];

  home.stateVersion = "21.05";
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    docker-credential-helpers
    libsecret
    calibre
    obsidian
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
    thunderbird-latest
    gamescope
    lutris
    pkgsCross.avr.stdenv.cc
    avrdude
    #bloom
    platformio
    ares
    ryujinx
    ctrtool
    hactool
    fastfetch
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
    alsa-utils
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
    dolphin-emu-beta
    #(callPackage ./kflash.py {})
    alsa-lib
    alsa-lib.dev
    gdb
    #(callPackage ./unityenv.nix {})
    easytag
    leoPkgs.cantata
    #calibre
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
    (discord-canary.override { withMoonlight = true; })
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
    wineWowPackages.staging
    gnumake
    (hiPrio gcc)
    hplip
    virtualbox
    dotnet-sdk
    #gmusicproxy
    mono
    #julia_06
    leoPkgs.bin
    #(import ./julia-oldpkgs.nix {version = "06";})
    #(import ./julia-oldpkgs.nix {version = "07";})
    #(import ./julia-oldpkgs.nix {version = "11";})
    leoPkgs.twemoji-ttf
    leoPkgs.determination-fonts
    leoPkgs.office-2007-fonts
    leoPkgs.vscode-fhs
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "leo60228";
    userEmail = "leo@60228.dev";
    extraConfig.init.defaultBranch = "main";
    extraConfig.hub.protocol = "ssh";
  };

  programs.go.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    grabKeyboardAndMouse = false;
    pinentryPackage = pkgs.pinentry-qt;
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = true;

  xdg.configFile."systemd/user/app-vesktop@.service.d/override.conf".text = ''
    [Unit]
    Wants=mpdiscord.service
  '';

  xdg.configFile."systemd/user/app-discord\\x2dcanary@.service.d/override.conf".text = ''
    [Unit]
    Wants=mpdiscord.service
  '';

  xdg.configFile."systemd/user/app-calibre\\x2dgui.service.d/override.conf".text = ''
    [Service]
    Environment=CALIBRE_USE_SYSTEM_THEME=1
  '';

  systemd.user.services.mpdiscord = {
    Unit = {
      Description = "mpdiscord";
    };

    Service = {
      ExecStart = "${pkgs.mpdiscord}/bin/mpdiscord /home/leo60228/.config/mpdiscord.toml";
    };
  };

  services.listenbrainz-mpd.enable = true;
  systemd.user.services."listenbrainz-mpd".Unit.After = lib.mkForce [ ];
  systemd.user.services."listenbrainz-mpd".Unit.Requires = lib.mkForce [ ];

  programs.bash.enable = true;
  programs.bash.initExtra = ''
    PROMPT_COLOR="1;2;37m"
    PS1='\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]$([ -z "$IN_NIX_SHELL" ] && echo "\u@\h" || echo nix-shell):\w]\\$\[\033[0m\] '
    export NIX_SHELL_PRESERVE_PROMPT=1

    [[ $- != *i* ]] && return

    eval $(hub alias -s)

    if [ -z "$NEOFETCH_RAN" ]; then
        fastfetch --config ${./files/fastfetch.jsonc}
        export NEOFETCH_RAN=1
    fi
  '';

  home.sessionVariables = {
    EDITOR = "vim";
    RUSTFMT = "rustfmt";
  };

  programs.bash.shellAliases = {
    cat = "bat";
    sudo = "sudo ";
  };

  home.file.".inputrc".text = ''
    $include /etc/inputrc
    "\e[A":history-search-backward
    "\e[B":history-search-forward
    set enable-bracketed-paste on
  '';

  home.file.".rustup/toolchains/system".source = pkgs.leoPkgs.rust.rust;

  home.file.".XCompose".source = ./files/XCompose;

  xdg.configFile."nixpkgs/config.nix".source = ./files/nixpkgs-config.nix;

  fonts.fontconfig.enable = lib.mkForce true;

  home.file.".gradle/gradle.properties" = {
    text = ''
      org.gradle.java.installations.paths=${pkgs.jdk8}
      org.gradle.java.installations.auto-download=false
    '';
  };

  home.file.".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
    "${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";

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

  programs.firefox = {
    enable = true;
    policies = {
      OverrideFirstRunPage = "about:newtab";
      EnableTrackingProtection.Value = true;
      PasswordManagerEnabled = false;
    };
    profiles.default = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
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

  programs.msmtp = {
    enable = true;
  };

  accounts.email.accounts."leo@60228.dev" = {
    primary = true;
    flavor = "gmail.com";
    address = "leo@60228.dev";
    realName = "leo60228";
    userName = "leo@60228.dev";
    msmtp.enable = true;
    msmtp.extraConfig.auth = "oauthbearer";
    passwordCommand = "${pkgs.oama}/bin/oama access leo@60228.dev";
  };
}
