let lib = import ../lib; in
lib.makeComponent "firefox"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    environment.etc."firefox/policies/policies.json".text = let
      prefs = {
        "dom.allow_scripts_to_close_windows" = true;
        "dom.webgpu.enabled" = true;
        "gfx.webrender.all" = true;
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "datareporting.policy.firstRunURL" = "";
        "browser.uiCustomization.state" = builtins.toJSON {
          currentVersion = 18;
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
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [ darkreader old-reddit-redirect reddit-enhancement-suite stylus greasemonkey ublock-origin bitwarden plasma-integration ];
      extraPolicies = {
        OverrideFirstRunPage = "about:newtab";
        EnableTrackingProtection = {
          Value = true;
        };
        PasswordManagerEnabled = false;
      };

      policies = {
        Extensions = {
          Install = map (x: x.src) extensions;
        };
        Preferences = lib.mapAttrs (k: v: {
          Value = v;
          Status = "locked";
        }) prefs;
      } // extraPolicies;
    in
      builtins.toJSON {
        inherit policies;
      };
  };
})
