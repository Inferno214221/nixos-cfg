{ inputs, lib, config, pkgs, ... }:
{
  home.file = {
    kali-dark = {
      enable = true;
      source = ./kali-dark.css;
      target = ".mozilla/firefox/g9bnymtb.default/chrome/kali-dark.css";
    };

    papirus = {
      enable = true;
      source = pkgs.fetchFromGitHub {
        owner = "PapirusDevelopmentTeam";
        repo = "firefox-papirus-icon-theme";
        rev = "480ce683e4c71afb4454c607a8e238a0248c1653";
        sha256 = "sha256-org0OEbZyiR0mu4kjF8FrPoibyxHVtkW94ykMtF+aeU=";
      };
      target = ".mozilla/firefox/g9bnymtb.default/chrome/firefox-papirus-icon-theme";
    };

    firefox-new-tab = {
      enable = true;
      source = ./firefox-new-tab;
      target = ".mozilla/firefox/g9bnymtb.default/firefox-new-tab";
    };

    # TODO: Build from source or exclude source from repo?
    simple-tab-groups-tweak = {
      enable = true;
      source = ./simple-tab-groups/addon/dist-zip/dist.xpi;
      target = ".mozilla/firefox/g9bnymtb.default/extensions/simple-tab-groups@drive4ik.xpi";
      force = true;
    };
  };

  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped {
      # nixExtensions
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        FirefoxHome = {
          Pocket = false;
          Snippets = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };

      extraPrefs = ''
        var {classes:Cc,interfaces:Ci,utils:Cu} = Components;
        try {
          Cu.import("resource:///modules/AboutNewTab.jsm");
          var newTabURL = "file:///home/inferno214221/.mozilla/firefox/g9bnymtb.default/firefox-new-tab/index.html";
          AboutNewTab.newTabURL = newTabURL;
        } catch(e) {
          Cu.reportError(e);
        }
      '';
    };
    profiles."g9bnymtb.default" = {
      name = "Default";
      isDefault = true;
      # extensions
      userChrome = ''
        @import "./firefox-papirus-icon-theme/userChrome.css";
        @import "./kali-dark.css";
      '';
      extraConfig = ''
        pref("general.config.filename", "autoconfig.cfg");
        pref("general.config.obscure_value", 0);
        pref("general.config.sandbox_enabled", false);
      '';
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "xpinstall.signatures.required" = false;
        "browser.uiCustomization.state" = ''{
          "placements": {
            "widget-overflow-fixed-list": [],
            "unified-extensions-area": [],
            "nav-bar": [
              "back-button",
              "forward-button",
              "stop-reload-button",
              "customizableui-special-spring1",
              "urlbar-container",
              "customizableui-special-spring2",
              "addon_darkreader_org-browser-action",
              "ublock0_raymondhill_net-browser-action",
              "_e4a8a97b-f2ed-450b-b12d-ee082ba24781_-browser-action",
              "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action",
              "downloads-button",
              "history-panelmenu",
              "sync-button",
              "fxa-toolbar-menu-button",
              "unified-extensions-button"
            ],
            "toolbar-menubar": [
              "menubar-items"
            ],
            "TabsToolbar": [
              "alltabs-button",
              "tabbrowser-tabs",
              "new-tab-button",
              "simple-tab-groups_drive4ik-browser-action",
              "personal-bookmarks"
            ],
            "PersonalToolbar": []
          },
          "seen": [
            "save-to-pocket-button",
            "addon_darkreader_org-browser-action",
            "simple-tab-groups_drive4ik-browser-action",
            "ublock0_raymondhill_net-browser-action",
            "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action",
            "_e4a8a97b-f2ed-450b-b12d-ee082ba24781_-browser-action",
            "developer-button"
          ],
          "dirtyAreaCache": [
            "unified-extensions-area",
            "nav-bar",
            "TabsToolbar",
            "PersonalToolbar",
            "widget-overflow-fixed-list"
          ],
          "currentVersion": 20,
          "newElementCount": 7
        }'';
      };
    };
  };
}