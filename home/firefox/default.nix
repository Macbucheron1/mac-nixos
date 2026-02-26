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
        "widget.use-xdg-desktop-portal.file-picker" = 1;
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
                  {
                    name = "Nix Version";
                    url = "https://lazamar.co.uk/nix-versions/";
                  }
                  {
                    name = "Pull Request Tracker";
                    url = "https://nixpkgs-tracker.ocfox.me/";
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
      extraConfig = builtins.readFile ./better-fox.js;
      userChrome = builtins.readFile ./userChrome.css; 
    };
  };
  stylix.targets.firefox.profileNames = [ username ];
}
