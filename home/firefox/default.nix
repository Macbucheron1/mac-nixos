{ userName, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.${userName} = {
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
                name = "HackTheBox";
                url = "https://app.hackthebox.com/home";
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
  stylix.targets.firefox.profileNames = [ userName ];
}