{
  config,
  osConfig,
  lib,
  pkgs,
  flakes,
  ...
}:

lib.mkIf osConfig.vris.graphical {
  home.packages =
    with pkgs;
    [
      bitwarden
      calibre
      obsidian
      signal-desktop
      libnotify
      glxinfo
      cantata
      zenity
      mpv
      appimage-run
      xclip
      xsel
      wl-clipboard
      gimp3
      vlc
      leoPkgs.twemoji-ttf
      leoPkgs.determination-fonts
      leoPkgs.office-2007-fonts
    ]
    ++ lib.optionals pkgs.stdenv.isx86_64 [
      steam-run
      discord-canary
      thunderbird-latest-bin
    ];

  xdg.configFile."systemd/user/app-vesktop@.service.d/override.conf".text = ''
    [Unit]
    Wants=mpdiscord.service
  '';

  xdg.configFile."systemd/user/app-discord\\x2dcanary@.service.d/override.conf".text = ''
    [Unit]
    Wants=mpdiscord.service
  '';

  xdg.configFile."systemd/user/app-calibre\\x2dgui@.service.d/override.conf".text = ''
    [Service]
    Environment=CALIBRE_USE_SYSTEM_THEME=1
    Environment=LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath [ pkgs.openssl ]}
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

  fonts.fontconfig.enable = lib.mkForce true;

  home.file.".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source =
    "${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";

  programs.firefox = {
    enable = true;
    package = osConfig.vris.firefox;
    policies = {
      OverrideFirstRunPage = "about:newtab";
      EnableTrackingProtection.Value = true;
      PasswordManagerEnabled = false;
    };
    profiles.${
      if osConfig.vris.firefox.unwrapped.binaryName == "firefox-devedition" then
        "dev-edition-default"
      else
        "default"
    } =
      {
        extensions.packages =
          with pkgs.nur.repos.rycee.firefox-addons;
          [
            darkreader
            old-reddit-redirect
            reddit-enhancement-suite
            stylus
            greasemonkey
            ublock-origin
            bitwarden
            plasma-integration
          ]
          ++ lib.optional (!osConfig.vris.workstation) pkgs.moonlight.firefox;
        settings = {
          "extensions.autoDisableScopes" = 0;
          "dom.allow_scripts_to_close_windows" = true;
          "dom.webgpu.enabled" = true;
          "gfx.webrender.all" = true;
          "browser.ctrlTab.recentlyUsedOrder" = false;
          "datareporting.policy.firstRunURL" = "";
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.fixup.dns_first_for_single_words" = true;
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
          "xpinstall.signatures.required" = osConfig.vris.workstation;
        };
        userChrome = ''
          #tabbrowser-tabs:not([overflow="true"]) ~ #alltabs-button {
            display: none !important;
          }
        '';
      };
  };
}
