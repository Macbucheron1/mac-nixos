{ username, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.${username} = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      bookmarks = {
        force = true;
        settings = [
          {
            toolbar = true;  # ce dossier spécial représente la barre
            bookmarks = [
              {
                name = "ChatGPT";
                url = "https://chatgpt.com/?model=gpt-5-instant";
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
                name = "Teams";
                url = "https://teams.microsoft.com/v2/";
              }
              {
                name = "Calendar";
                url = "https://calendar.google.com/calendar/u/0/r";
              }
            ];
          }
        ];
      };
      extensions.force = true;
    };

    policies = {
      ExtensionSettings = {
        # Dark Reader
        "addon@darkreader.org" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };

        # Bitwarden
        "446900e4-71c2-419f-a6a7-df9c091e268b" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
      };
    };
  };
  stylix.targets.firefox.profileNames = [ username ];
}