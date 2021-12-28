let lib = import ../lib; in
lib.makeComponent "firefox"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    environment.etc."firefox/policies/policies.json".text = let
      firefox-unwrapped = (import ./firefox.nix pkgs.lib).unwrapped.overrideAttrs (oldAttrs: {
        passthru.applicationName = "firefox";
      });
      prefs = {
        "dom.allow_scripts_to_close_windows" = true;
        "dom.webgpu.enabled" = true;
        "gfx.webrender.all" = true;
        "browser.ctrlTab.recentlyUsedOrder" = false;
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
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [ darkreader old-reddit-redirect reddit-enhancement-suite stylus greasemonkey ublock-origin bitwarden ];
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
