{ username, firefox-addons, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.${username} = {
      isDefault = true;
      settings = {
        "browser.startup.page" = 1;
        "browser.startup.homepage" = "https://www.google.com/";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      
      extensions = {
        force = true;
        packages = with firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          bitwarden
          darkreader
          privacy-badger
          vimium
        ];
      };

      search = {
        force = true;
        default = "google";
        engines = {
          ddg.metaData.hidden = true;
          bing.metaData.hidden = true;
          qwant.metaData.hidden = true;
          wikipedia.metaData.hidden = true;
          perplexity.metaData.hidden = true;


          nix-packages = {
            name = "Nix Packages";
            urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                    { name = "type"; value = "packages"; }
                    { name = "channel"; value = "unstable"; }
                    { name = "query"; value = "{searchTerms}"; }
                ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          nixos-options = {
            name = "Nixos Options";
            urls = [{
                template = "https://search.nixos.org/options";
                params = [
                    { name = "type"; value = "options"; }
                    { name = "channel"; value = "unstable"; }
                    { name = "query"; value = "{searchTerms}"; }
                ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };

          youtube = {
              name = "YouTube";
              urls = [{ template = "https://www.youtube.com/results?search_query={searchTerms}"; }];
              icon = "https://www.youtube.com/favicon.ico";
              definedAliases = [ "@yt" ];
          };

          home-manager-options = {
              name = "Home Manager Options";
              urls = [{ 
                  template = "https://home-manager-options.extranix.com/"; 
                  params = [
                      { name = "release"; value = "master"; }
                      { name = "query"; value = "{searchTerms}"; }
                  ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@hm" ];
          };

        };
      };

      bookmarks = {
        force = true;
        settings = [
          {
            toolbar = true;  # ce dossier spécial représente la barre
            bookmarks = [
              {
                name = "ChatGPT";
                url = "https://chatgpt.com";
              }
              {
                name = "Github";
                url = "https://github.com/Macbucheron1";
              }
              {
                name = "Youtube";
                url = "https://www.youtube.com";
              }
              {
                name = "Outlook";
                url = "https://outlook.office365.com/mail/";
              }
              {
                name = "CentraleSupélec";
                bookmarks = [
                  {
                    name = "Edunao";
                    url = "https://centralesupelec.edunao.com/";
                  }
                ];
              }
              {
                name = "Nix";
                bookmarks = [
                  {
                    name = "Home Manager Search";
                    url  = "https://home-manager-options.extranix.com/?query=&release=master";
                  }
                  {
                    name = "Packages Search";
                    url = "https://search.nixos.org/packages";
                  }
                ];
              }
              {
                name = "Cyber";
                bookmarks = [
                  {
                    name = "HackTheBox";
                    url = "https://app.hackthebox.com/home";
                  }
                  {
                    name = "Root-Me";
                    url = "https://www.root-me.org/Mac-812606?lang=fr#d88e573684dce5992c29f1a7c407c483";
                  }
                  {
                    name = "PortSwigger";
                    url = "https://portswigger.net/web-security";
                  }
                ];
              }
              {
                name = "Social";
                bookmarks = [
                  {
                    name = "Teams";
                    url = "https://teams.microsoft.com/v2/";
                  }
                  {
                    name = "Telegram";
                    url  = "https://web.telegram.org/a/";
                  }

                ];
              }
              {
                name = "Calendar";
                url = "https://calendar.google.com/calendar/u/0/r";
              }
            ];
          }
        ];
      };
      extraConfig = ''
        /****************************************************************************
         * Betterfox                                                                *
         * "Ad meliora"                                                             *
         * version: 146                                                             *
         * url: https://github.com/yokoffing/Betterfox                              *
        ****************************************************************************/

        /****************************************************************************
         * SECTION: SECUREFOX                                                       *
        ****************************************************************************/
        /** TRACKING PROTECTION ***/
        user_pref("browser.contentblocking.category", "strict");
        user_pref("browser.download.start_downloads_in_tmp_dir", true);
        user_pref("browser.uitour.enabled", false);
        user_pref("privacy.globalprivacycontrol.enabled", true);

        /** OCSP & CERTS / HPKP ***/
        user_pref("security.OCSP.enabled", 0);
        user_pref("privacy.antitracking.isolateContentScriptResources", true);
        user_pref("security.csp.reporting.enabled", false);

        /** SSL / TLS ***/
        user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);
        user_pref("browser.xul.error_pages.expert_bad_cert", true);
        user_pref("security.tls.enable_0rtt_data", false);

        /** DISK AVOIDANCE ***/
        user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
        user_pref("browser.sessionstore.interval", 60000);

        /** SHUTDOWN & SANITIZING ***/
        user_pref("privacy.history.custom", true);
        user_pref("browser.privatebrowsing.resetPBM.enabled", true);

        /** SEARCH / URL BAR ***/
        user_pref("browser.urlbar.trimHttps", true);
        user_pref("browser.urlbar.untrimOnUserInteraction.featureGate", true);
        user_pref("browser.search.separatePrivateDefault.ui.enabled", true);
        user_pref("browser.search.suggest.enabled", false);
        user_pref("browser.urlbar.quicksuggest.enabled", false);
        user_pref("browser.urlbar.groupLabels.enabled", false);
        user_pref("browser.formfill.enable", false);
        user_pref("network.IDN_show_punycode", true);

        /** HTTPS-ONLY MODE ***/
        user_pref("dom.security.https_only_mode", true);
        user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);

        /** PASSWORDS ***/
        user_pref("signon.formlessCapture.enabled", false);
        user_pref("signon.privateBrowsingCapture.enabled", false);
        user_pref("network.auth.subresource-http-auth-allow", 1);
        user_pref("editor.truncate_user_pastes", false);

        /** EXTENSIONS ***/
        user_pref("extensions.enabledScopes", 5);

        /** HEADERS / REFERERS ***/
        user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

        /** CONTAINERS ***/
        user_pref("privacy.userContext.ui.enabled", true);

        /** VARIOUS ***/
        user_pref("pdfjs.enableScripting", false);

        /** SAFE BROWSING ***/
        user_pref("browser.safebrowsing.downloads.remote.enabled", false);

        /** MOZILLA ***/
        user_pref("permissions.default.desktop-notification", 2);
        user_pref("permissions.default.geo", 2);
        user_pref("geo.provider.network.url", "https://beacondb.net/v1/geolocate");
        user_pref("browser.search.update", false);
        user_pref("permissions.manager.defaultsUrl", "");
        user_pref("extensions.getAddons.cache.enabled", false);

        /** TELEMETRY ***/
        user_pref("datareporting.policy.dataSubmissionEnabled", false);
        user_pref("datareporting.healthreport.uploadEnabled", false);
        user_pref("toolkit.telemetry.unified", false);
        user_pref("toolkit.telemetry.enabled", false);
        user_pref("toolkit.telemetry.server", "data:,");
        user_pref("toolkit.telemetry.archive.enabled", false);
        user_pref("toolkit.telemetry.newProfilePing.enabled", false);
        user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
        user_pref("toolkit.telemetry.updatePing.enabled", false);
        user_pref("toolkit.telemetry.bhrPing.enabled", false);
        user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
        user_pref("toolkit.telemetry.coverage.opt-out", true);
        user_pref("toolkit.coverage.opt-out", true);
        user_pref("toolkit.coverage.endpoint.base", "");
        user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
        user_pref("browser.newtabpage.activity-stream.telemetry", false);
        user_pref("datareporting.usage.uploadEnabled", false);

        /** EXPERIMENTS ***/
        user_pref("app.shield.optoutstudies.enabled", false);
        user_pref("app.normandy.enabled", false);
        user_pref("app.normandy.api_url", "");

        /** CRASH REPORTS ***/
        user_pref("breakpad.reportURL", "");
        user_pref("browser.tabs.crashReporting.sendReport", false);

        /****************************************************************************
         * SECTION: PESKYFOX                                                        *
        ****************************************************************************/
        /** MOZILLA UI ***/
        user_pref("extensions.getAddons.showPane", false);
        user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
        user_pref("browser.discovery.enabled", false);
        user_pref("browser.shell.checkDefaultBrowser", false);
        user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
        user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
        user_pref("browser.preferences.moreFromMozilla", false);
        user_pref("browser.aboutConfig.showWarning", false);
        user_pref("browser.startup.homepage_override.mstone", "ignore");
        user_pref("browser.aboutwelcome.enabled", false);
        user_pref("browser.profiles.enabled", true);

        /** THEME ADJUSTMENTS ***/
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
        user_pref("browser.compactmode.show", true);
        user_pref("browser.privateWindowSeparation.enabled", false); // WINDOWS

        /** AI ***/
        user_pref("browser.ml.enable", false);
        user_pref("browser.ml.chat.enabled", false);
        user_pref("browser.ml.chat.menu", false);
        user_pref("browser.tabs.groups.smart.enabled", false);
        user_pref("browser.ml.linkPreview.enabled", false);

        /** FULLSCREEN NOTICE ***/
        user_pref("full-screen-api.transition-duration.enter", "0 0");
        user_pref("full-screen-api.transition-duration.leave", "0 0");
        user_pref("full-screen-api.warning.timeout", 0);

        /** URL BAR ***/
        user_pref("browser.urlbar.trending.featureGate", false);

        /** NEW TAB PAGE ***/
        user_pref("browser.newtabpage.activity-stream.default.sites", "");
        user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
        user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
        user_pref("browser.newtabpage.activity-stream.showSponsored", false);
        user_pref("browser.newtabpage.activity-stream.showSponsoredCheckboxes", false);

        /** DOWNLOADS ***/
        user_pref("browser.download.manager.addToRecentDocs", false);

        /** PDF ***/
        user_pref("browser.download.open_pdf_attachments_inline", true);

        /** TAB BEHAVIOR ***/
        user_pref("browser.bookmarks.openInTabClosesMenu", false);
        user_pref("browser.menu.showViewImageInfo", true);
        user_pref("findbar.highlightAll", true);
        user_pref("layout.word_select.eat_space_to_next_word", false);

        /****************************************************************************
         * START: MY OVERRIDES                                                      *
        ****************************************************************************/
        // visit https://github.com/yokoffing/Betterfox/wiki/Common-Overrides
        // visit https://github.com/yokoffing/Betterfox/wiki/Optional-Hardening
        // Enter your personal overrides below this line:

        // PREF: disable login manager
        user_pref("signon.rememberSignons", false);

        // PREF: disable address and credit card manager
        user_pref("extensions.formautofill.addresses.enabled", false);
        user_pref("extensions.formautofill.creditCards.enabled", false);

        // PREF: ask where to save every file
        user_pref("browser.download.useDownloadDir", false);

        // PREF: ask whether to open or save new file types
        user_pref("browser.download.always_ask_before_handling_new_types", true);

        /****************************************************************************
         * SECTION: SMOOTHFOX                                                       *
        ****************************************************************************/
        // visit https://github.com/yokoffing/Betterfox/blob/main/Smoothfox.js
        // Enter your scrolling overrides below this line:


        /****************************************************************************
         * END: BETTERFOX                                                           *
        ****************************************************************************/
      '';
      userChrome = ''
        :root {
          &[uidensity="compact"] {
            --tab-min-height: 20px !important;
          }

          /* Urlbar and separator colors */
          --toolbar-field-background-color: #181818 !important;
          --toolbar-field-focus-background-color: #181818 !important;
          --toolbar-field-color: #ffffff !important;
          --toolbar-field-focus-color: #ffffff !important;
          --chrome-content-separator-color: #181818 !important;
        }

        /* Notification bar fixed at bottom */
        #notifications-toolbar {
          position: fixed !important;
          left: 0;
          right: 0;
          bottom: 0;
          z-index: 9;
        }

        /* Hide sidebar header */
        #sidebar-header {
          display: none !important;
        }

        /* Nav bar hidden until hover/focus */
        #nav-bar {
          position: absolute !important;
          top: 0 !important;
          left: 0;
          right: 0;
          margin: 0 !important;
          padding: 0 !important;
          overflow: hidden !important;
          z-index: 9999 !important;
          opacity: 0 !important;
          background-color: #181818 !important;
        }

        #urlbar {
          opacity: 0 !important;
          pointer-events: none !important;
        }

        #navigator-toolbox:is(:hover, :focus-within) #nav-bar {
          top: 44px !important;
          opacity: 1 !important;
        }

        #navigator-toolbox:is(:hover, :focus-within) #urlbar {
          opacity: 1 !important;
          pointer-events: auto !important;
        }

        /* Toolbox background + no separator line */
        #navigator-toolbox {
          position: relative !important;
          z-index: 10000 !important;
          background-color: #181818 !important;
          border-bottom: none !important;
          box-shadow: none !important;
        }

        /* Tabs */
        .tab-background {
          min-height: 0 !important;
          background-color: #282828 !important;
          border: 1px solid rgba(128, 128, 128, 1.0) !important;
        }

        .tab-text {
          margin: 0 auto !important;
        }

        /* Make tabs wide */
        .tabbrowser-tab[fadein] {
          max-width: 100vw !important;
        }

        /* Center tab icon + tighten label width */
        .tab-icon-stack {
          margin-inline-start: auto !important;
        }

        .tab-label-container {
          max-width: min-content !important;
          margin-inline-end: auto !important;
        }

        /* Titlebar spacers */
        .titlebar-spacer[type="pre-tabs"],
        .titlebar-spacer[type="post-tabs"] {
          width: 30px !important;
        }

        :root:not([sizemode="normal"]) .titlebar-spacer[type="pre-tabs"] {
          display: block !important;
        }

        @media (max-width: 500px) {
          .titlebar-spacer[type="post-tabs"] {
            display: block !important;
          }
        }

        /* Hide window + tab chrome buttons */
        .tab-close-button,
        #TabsToolbar .toolbarbutton-1,
        .titlebar-buttonbox-container {
          display: none !important;
        }

        /* Tabs toolbar background and text */
        #TabsToolbar {
          background-color: #181818 !important;
        }

        .tabbrowser-tab[selected="true"] .tab-background {
          background-color: #484848 !important;
        }

        .tabbrowser-tab .tab-label {
          color: white !important;
        }

        /* Toolbar labels/icons white (but not everything) */
        #nav-bar .toolbarbutton-text,
        #nav-bar .toolbarbutton-icon,
        #TabsToolbar .toolbarbutton-text,
        #TabsToolbar .toolbarbutton-icon {
          color: white !important;
        }

        /* Only built‑in icons white, not extensions */
        #nav-bar toolbarbutton:not(.webextension-browser-action) .toolbarbutton-icon {
          filter: brightness(0) invert(1) !important;
        }

        /* Global font */
        * {
          font-family: system-ui !important;
        }

        /* Dark menus/panels */
        menupopup,
        panel {
          --panel-background: black !important;
          --panel-color: white !important;
          --panel-border-radius: 0px !important;
        }

        #appMenu-popup,
        #appMenu-popup * {
          background-color: #000 !important;
          color: #fff !important;
        }

        /* Unified Extensions: grid layout */
        #unified-extensions-view {
          width: fit-content !important;
        }

        #unified-extensions-panel .panel-subview-body > * {
          display: grid !important;
          grid-template-columns: repeat(5, 1fr) !important;
          justify-items: center !important;
          gap: 0 !important;
        }

        #unified-extensions-panel #unified-extensions-area,
        #unified-extensions-panel #overflowed-extensions-list {
          display: grid !important;
          grid-template-columns: repeat(5, 1fr) !important;
          justify-items: center !important;
        }

        :is(panelview, #unified-extensions-area, #overflowed-extensions-list) .toolbaritem-combined-buttons,
        #unified-extensions-panel .unified-extensions-item {
          margin: 0 !important;
        }

        #unified-extensions-panel #unified-extensions-area > .unified-extensions-item,
        #unified-extensions-panel #overflowed-extensions-list > .unified-extensions-item {
          width: 60.6px !important;
          height: 60.6px !important;
          max-width: none !important;
          max-height: none !important;
          padding: 0 !important;
          margin: 0 !important;
        }

        #unified-extensions-panel .unified-extensions-item-row-wrapper {
          padding: 0 !important;
          margin: 0 !important;
        }

        #unified-extensions-panel #unified-extensions-area .unified-extensions-item-action-button,
        #unified-extensions-panel #overflowed-extensions-list .unified-extensions-item-action-button {
          width: 100% !important;
          height: 100% !important;
          padding: 0 !important;
          margin: 0 !important;
        }

        #unified-extensions-panel #unified-extensions-area .unified-extensions-item-action-button > .toolbarbutton-badge-stack,
        #unified-extensions-panel #overflowed-extensions-list .unified-extensions-item-action-button > .toolbarbutton-badge-stack,
        #unified-extensions-panel .unified-extensions-list .unified-extensions-item-action-button {
          display: grid !important;
          width: 100% !important;
          height: 100% !important;
          padding: 20% !important;
          margin: 0 !important;
          justify-content: center !important;
          align-items: center !important;
        }

        #unified-extensions-panel .unified-extensions-item-action-button image.toolbarbutton-icon {
          width: 26px !important;
          height: 26px !important;
          margin: auto !important;
        }

        #unified-extensions-panel .unified-extensions-list,
        #unified-extensions-panel .unified-extensions-item-menu-button,
        #unified-extensions-panel .unified-extensions-item-contents,
        #unified-extensions-panel .unified-extensions-item-action-button > .toolbarbutton-text {
          display: none !important;
        }

        #unified-extensions-panel .subviewbutton {
          margin: 0 !important;
        }

        #nav-bar-customization-target > .unified-extensions-item {
          filter: saturate(0%) brightness(120%) !important;
        }

        #customization-panelHolder > #unified-extensions-area > toolbarpaletteitem:not([notransition])[place="panel"] {
          border-block-width: 0 !important;
          transition: padding var(--drag-drop-transition-duration) ease-in-out !important;
        }

        #customization-panelHolder > #unified-extensions-area > toolbarpaletteitem:not([notransition])[place="panel"][dragover="before"] {
          padding-inline-start: 20px !important;
        }

        #customization-panelHolder > #unified-extensions-area > toolbarpaletteitem:not([notransition])[place="panel"][dragover="after"] {
          padding-inline-end: 20px !important;
        }

        /* Urlbar field: dark background, white text */
        #urlbar,
        #urlbar-background,
        #urlbar-input-container {
          background-color: #181818 !important;
        }

        #urlbar-input,
        #urlbar-input::placeholder {
          color: #ffffff !important;
        }

        /* Urlbar suggestions: dark background, white text, colored icons */
        .urlbarView,
        .urlbarView-row,
        .urlbarView-row-inner,
        .urlbarView-row[aria-selected="true"] {
          background-color: #000 !important;
        }

        /* Highlight currently selected urlbar suggestion (Tab selection) */
        .urlbarView-row[aria-selected="true"] .urlbarView-row-inner {
          background-color: #303030 !important;  /* or any color you like */
          outline: 1px solid #666 !important;    /* optional, for extra contrast */
        }

        /* Optional: also highlight on keyboard focus */
        .urlbarView-row:is([selected], [aria-selected="true"]) .urlbarView-row-inner {
          background-color: #303030 !important;
        }

        .urlbarView-title,
        .urlbarView-secondary,
        .urlbarView-url,
        .urlbarView-action {
          color: #fff !important;
        }

        #urlbar .search-one-offs button,
        #urlbar .search-one-offs button .toolbarbutton-icon,
        #urlbar .search-one-offs .searchbar-engine-one-off-item,
        #urlbar .search-one-offs .searchbar-engine-one-off-item .toolbarbutton-icon,
        #urlbar .search-one-offs .urlbarView-favicon,
        #urlbar .search-one-offs .urlbarView-favicon > img,
        #urlbar .search-one-offs .urlbarView-favicon > image {
          color: initial !important;
          filter: none !important;
        }

        /* Darken the strip under the tabs/content edge */
        #navigator-toolbox::after,
        #tabbrowser-tabbox,
        #browser,
        #appcontent {
          background-color: #181818 !important;
        }
      '';
    };
  };
  stylix.targets.firefox.profileNames = [ username ];
}
